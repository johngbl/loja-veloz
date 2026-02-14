const express = require("express");
const app = express();
const port = process.env.PORT || 3000;

app.get("/", (req, res) => {
  res.json({ service: "gateway", env: process.env });
});

app.get("/health", (req, res) => res.send("ok"));

app.listen(port, () => console.log(`Gateway listening on ${port}`));
