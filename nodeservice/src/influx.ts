import { InfluxDBClient, Point } from "@influxdata/influxdb3-client";

const url = "https://eu-central-1-1.aws.cloud2.influxdata.com";
const token: string | undefined = process.env.INFLUXDB_TOKEN;;
const database = "services-test-project";

let cli: InfluxDBClient | null = null;

export function initRetriever() {
  cli = new InfluxDBClient({
    host: url,
    token: token,
  });
}

export interface Entry {
  sender: string;
  time: string;
  value: number;
}

export function query(senders: string[]): string {
  let q = `SELECT *
FROM "measurement"
WHERE
time >= now() - interval '3 minutes'`;
  if (senders.length === 0) {
    return q;
  }
  q += `\nAND\n"sender" IN ('${senders[0]}'`;
  for (const s of senders.slice(1)) {
    q += `, '${s}'`;
  }
  q += ")";
  return q;
}

export async function retrieve(senders: string[]): Promise<Entry[]> {
  const r: Entry[] = [];
  if (cli === null) {
    return r;
  }
  const rows = cli.query(query(senders), database);
  for await (const row of rows) {
    r.push({sender: row["sender"], time: row["time"], value: row["value"]});
  }
  return r;
}

export async function teardownRetriever(): Promise<void> {
  if (cli !== null) {
    await cli.close();
  }
}
