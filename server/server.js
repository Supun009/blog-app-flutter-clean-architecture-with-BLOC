const express = require("express");
const mongoose = require("mongoose");
const authroute = require("./routes/authroute");
const blogRout = require("./routes/blogRouter");

require('dotenv').config();


const PORT =  3000;
const DB = `${process.env.DB}`;



const app = express();
app.use(express.json());
app.use(authroute);
app.use(blogRout)

mongoose.connect(DB).then(()=> {
    console.log("DB is connetcted");
}).catch((e)=> {
    console.log(e)
})

app.listen(PORT, "0.0.0.0", ()=> {
    console.log(`Server running on ${PORT} `)
})