//Imports
const express = require("express");
const mongoose = require("mongoose");
const http = require("http");
const Game = require("./models/game.js");
const getSentence = require("./apis/getSentence.js");

//Creating server
const app = express();
const port = process.env.PORT || 3000;
var server = http.createServer(app);
var io = require("socket.io")(server);

//Middleware : frontend<->middleware<->backend
app.use(express.json());

//listening to socket io events from client (flutter code)
io.on("connection", (socket)=>{
    console.log(socket.id);
    socket.on("createGame", async ({nickname})=>{
      try{
        let game = Game();
        let sentence = await getSentence();
        let player = {
          socketID : socket.id,
          nickname,
          isPartyLeader : true,
        }
        game.words = sentence;
        game.players.push(player);
        game = await game.save();

        const gameId = game._id.toString();
        socket.join(gameId);
        io.to(gameId).emit("updateGame", game);
      }catch(e){
        console.log(e);
      }
    });
});

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
