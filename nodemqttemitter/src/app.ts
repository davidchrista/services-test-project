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

export async function* generate(
  maxNb: number,
  delayBase: number
): AsyncGenerator<string> {
  if (delayBase <= 0.0) {
    delayBase = 0.001
  }
  let i = 0;
  let val = Math.random() * 30;
  while (cont && (maxNb < 0 || i < maxNb)) {
    const delay = Math.random() * delayBase * 1000;
    const change = ((Math.random() * 0.5 - 0.25) * delay) / delayBase / 1000;
    val += change;
    await sleep(delay);
    yield JSON.stringify({
      id: i,
      sender: "nodemqttemitter",
      message: `Value: ${val}`,
    });
    i++;
  }
  return;
}

(async () => {
  for await (const s of generate(-1, 5.0)) {
    publish(s);
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
