import express from "express";
import cors from "cors";
import { auth } from "express-oauth2-jwt-bearer";

const checkJwt = auth({
  audience: "http://localhost:4000",
  issuerBaseURL: "https://dev-gzm0pgbh.us.auth0.com/",
});

const app = express();
const port = 4000;

app
  .use(cors())
  .get("/", checkJwt, (_req, res) => {
    res.send("Hello Node!");
  })
  .get("/other", (_req, res) => {
    res.send("Hello Other!");
  })
  .listen(port, () => {
    return console.log(`Express is listening at http://localhost:${port}`);
  });
