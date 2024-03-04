import { query } from "./influx";

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
