import { convertTime, query } from "./influx";

describe("influx functionality test", () => {
  it("should create empty queries correctly", () => {
    const q = query([]);
    expect(q).toBe(`SELECT *
FROM "measurement"
WHERE
time >= now() - interval '3 minutes'`);
  });

  it("should create queries with single selection correctly", () => {
    const q = query(["gomqttemitter"]);
    expect(q).toBe(`SELECT *
FROM "measurement"
WHERE
time >= now() - interval '3 minutes'
AND
"sender" IN ('gomqttemitter')`);
  });

  it("should create queries with multi selection correctly", () => {
    const q = query(["gomqttemitter", "test"]);
    expect(q).toBe(`SELECT *
FROM "measurement"
WHERE
time >= now() - interval '3 minutes'
AND
"sender" IN ('gomqttemitter', 'test')`);
  });
});

describe("influx time conversion", () => {
  it("should convert time correctly", () => {
    const s = "1709641075817.226410";
    const t = convertTime(s);
    expect(t).toBe("2024-03-05T12:17:55.817226410Z");
  });
});
