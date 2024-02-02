import mqtt from "mqtt";

const protocol = "mqtts";
const broker = "v090e996.ala.us-east-1.emqxsl.com";
const port = 8883;
const topic = "testdata/1";
const username = "david";
const password = "Passw0rd";

const clientId = `node-client-${Math.random().toString(16).substring(2, 8)}`;

const client = mqtt.connect(`${protocol}://${broker}:${port}`, {
  clientId,
  username,
  password,
});

const qos = 0;

const publish = (payload: string) => {
  client.publish(topic, payload, { qos }, (error) => {
    if (error) {
      console.error(error);
    } else {
      //console.log(`publish success, topic : ${topic}, payload: ${payload}`);
    }
  });
};

const sleep = (ms: number) => new Promise((resolve) => setTimeout(resolve, ms));

let cont = true;

(async () => {
  let i = 0;
  while (cont) {
    const delay = Math.random() * 5 * 1000;
    await sleep(delay);
    publish(
      JSON.stringify({
        id: i,
        sender: "nodemqtt",
        message: `Duration: ${delay / 1000}`,
      })
    );
    i++;
  }
})();

const signals = new Map<string, number>([
  ["SIGHUP", 1],
  ["SIGINT", 2],
  ["SIGTERM", 15],
]);

const shutdown = (signal: string, value: number) => {
  console.log("shutdown!");
  cont = false;
  console.log(`stopped by ${signal} with value ${value}`);
  process.exit(128 + value);
};

signals.forEach((val, signal) => {
  process.on(signal, () => {
    console.log(`process received a ${signal} signal`);
    shutdown(signal, val);
  });
});
