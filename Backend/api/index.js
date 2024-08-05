import express from "express";

const app = express();

app.get("/", (req, res)=>res.send("Express app is running"));

app.listen(3000, ()=>console.log("Server is running on port 8000"));

module.exports = app;