const express = require("express");
const app = express();
const bodyParser = require("body-parser");
const cors = require("cors");

app.use(bodyParser.json());
app.use(cors());
let port = 5000;
app.get("/api/task", (req, res) => {
  res.json({ server: "task" });
});

app.listen(port, () => {
  console.log("Task-service running on\n\nLocalhost:" + port);
});
