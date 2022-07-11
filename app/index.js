const express = require("express");

const app = express();

app.get("/", (req, res) => {
  res.send("This is my SRE app");
});

app.get("/me", (req, res) => {
  res.send("The answer is 42!");
});

app.listen(5000, () => {
  console.log("listening");
});
