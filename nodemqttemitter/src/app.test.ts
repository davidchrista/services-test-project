import { generate } from "./app"

describe("main app test", () => {
  it("should generate data correctly", async () => {
    const a = (await generate(1, 0.1).next()).value;
    expect(a).toMatch(/nodemqttemitter.*Value:/);
  })

  it("should generate right amount of values", async () => {
    const s: string[] = [];
    for await (const v of generate(3, 0.1)) {
      s.push(v);
    }
    expect(s).toHaveLength(3);
  })

  it("should not crash when 0.0 delay specified", async () => {
    await generate(1, 0.0);
  })
})