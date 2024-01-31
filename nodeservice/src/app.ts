import express from "express";
import cors from "cors";
import { auth } from "express-oauth2-jwt-bearer";

const checkJwt = auth({
  audience: "http://localhost:4000",
  issuerBaseURL: "https://dev-gzm0pgbh.us.auth0.com/",
});

const app = express();
const port = 4000;

const server = app
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

const signals = new Map<string, number>([
  ["SIGHUP", 1],
  ["SIGINT", 2],
  ["SIGTERM", 15],
]);

const shutdown = (signal: string, value: number) => {
  console.log("shutdown!");
  server.close(() => {
    console.log(`server stopped by ${signal} with value ${value}`);
    process.exit(128 + value);
  });
};

signals.forEach((val, signal) => {
  process.on(signal, () => {console.log(`process received a ${signal} signal`);
  shutdown(signal, val);})
});
