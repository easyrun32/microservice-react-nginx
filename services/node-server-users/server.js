const express = require("express");
const app = express();
const bodyParser = require("body-parser");
const cors = require("cors");

app.use(bodyParser.json());
app.use(cors());
let port = 5000;
app.get("/api/users", (req, res) => {
  res.json({ server: "users" });
});

app.listen(port, () => {
  console.log("Users-service running on\n\nLocalhost:" + port);
});
