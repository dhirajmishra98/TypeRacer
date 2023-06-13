//Imports
const express = require("express");
const mongoose = require("mongoose");
const http = require("http");
const Game = require("./models/game.js");
const getSentence = require("./apis/getSentence.js");
const { time } = require("console");

//Creating server
const app = express();
const port = process.env.PORT || 3000;
var server = http.createServer(app);
var io = require("socket.io")(server);

//Middleware : frontend<->middleware<->backend
app.use(express.json());

//listening to socket io events from client (flutter code)
io.on("connection", (socket) => {
  socket.on("createGame", async ({ nickname }) => {
    try {
      let game = Game();
      let sentence = await getSentence();
      let player = {
        socketID: socket.id,
        nickname,
        isPartyLeader: true,
      };
      game.words = sentence;
      game.players.push(player);
      game = await game.save();

      const gameId = game._id.toString();
      socket.join(gameId);
      io.to(gameId).emit("updateGame", game);
    } catch (e) {
      console.log(e);
    }
  });

  socket.on("joinGame", async ({ nickname, gameId }) => {
    try {
      if (!gameId.match(/^[0-9a-fA-F]{24}$/)) {
        socket.emit("notCorrectGame", "Please enter a valid gameID");
        return;
      }

      let game = await Game.findById(gameId);
      if (game.isJoin) {
        const id = game._id.toString();
        let player = {
          nickname,
          socketID: socket.id,
        };
        game.players.push(player);
        socket.join(gameId);
        game = await game.save();
        io.to(gameId).emit("updateGame", game);
      } else {
        socket.emit(
          "notCorrectGame",
          "The game is in progress, Please try again later!"
        );
      }
    } catch (e) {
      console.log(e);
    }
  });

  socket.on("userInput", async({userInput, gameId})=>{
    let game = await Game.findById(gameId);
    if(!game.isJoin && !game.isOver){
      let player = game.players.find((playerr)=> playerr.socketID === socket.id);

      if(game.words[player.currentWordIndex] === userInput.trim()){
        player.currentWordIndex = player.currentWordIndex+1;
        if(player.currentWordIndex !== game.words.length){
          game = await game.save();
          io.to(gameId).emit("updateGame",game);
        }else{
          let endTime = new Date().getTime();
          let {startTimer} = game;
          player.WPM = calculateWPM(startTimer, endTime, player);
          game = await game.save();
          socket.emit("done");
          io.to(gameId).emit("updateGame",game);
        }
      }
    }
  });

  socket.on("timer", async ({ playerId, gameId }) => {
    try {
      console.log("timer started");
      let countDown = 5;
      let game = await Game.findById(gameId);
      let player = game.players.id(playerId);
      if (player.isPartyLeader) {
        let timerId = setInterval(async () => {
          if (countDown >= 0) {
            io.to(gameId).emit("timer", {
              countDown,
              msg: "Game Starting...",
            });
            countDown--;
          } else {
            game.isJoin = false;
            game = await game.save();
            io.to(gameId).emit("updateGame", game);
            startGameClock(gameId);
            clearInterval(timerId);
          }
        }, 1000);
      }
    } catch (e) {
      console.log(e);
    }
  });
});

//functions needed to be executed in server
const startGameClock = async (gameId) => {
  let game = await Game.findById(gameId);
  game.startTimer = new Date().getTime();
  game = await game.save();

  let time = 120; //later manually setup its 120sec now
  let timerId = setInterval(
    (function gameIntervalFunc() {
      if (time >= 0) {
        const timeFormat = calculateTime(time);
        io.to(gameId).emit("timer", {
          countDown: timeFormat,
          msg: "Time Remaining...",
        });
        console.log(time);
        time--;
      }else{
        (async ()=>{
          try{
          let endTime = new Date().getTime();
          let game = await Game.findById(gameId);
          let {startTimer} = game;
          game.isOver  = true;
          game.players.forEach((player,index)=>{
            if(player.WPM === -1){
              game.players[index].WPM = calculateWPM(startTimer,endTime,player);
            }
          });
          game = await game.save();
          io.to(gameId).emit("updateGame",game);
          clearInterval(timerId);
          } catch (e){
            console.log(e);
          }
        })();
      }
      return gameIntervalFunc;
    })(),
    1000
  );
};

const calculateTime = (time) => {
  let min = Math.floor(time / 60);
  let sec = time % 60;

  return `${min}:${sec < 10 ? "0" + sec : sec}`;
};

const calculateWPM = (startTimer, endTime, player) => {
  const timeTakenInSec = (endTime-startTimer)/1000;
  const timeTakenInMin = timeTakenInSec/60;
  const WPM = Math.floor(player.currentWordIndex/timeTakenInMin);
  return WPM;
}

//Connect to MongoDB
const DB =
  "mongodb+srv://gobindmishra22:9811266945dhiraj@typeracer.injgfbz.mongodb.net/?retryWrites=true&w=majority";
mongoose
  .connect(DB)
  .then(() => {
    console.log("Connection successfull to mongodb");
  })
  .catch((e) => {
    console.log("error while connecting to mongodb");
  });

//Listen to Server
server.listen(port, "0.0.0.0", () => {
  console.log(`server started and running on ${port}`);
});

//Useful comments
//dependencies : for product after deployment, command : npm i <package name>
//dev dependencies : for developers esiness only , not useful after deployemnet so nodemon is used in devdependes command: npm i <package name> --save-dev
