import React from "react";
import { render, screen, within } from "@testing-library/react";
import { Data } from "./fetch";
import DataTable from "./DataTable";

const data: Data = {
  sender: "sender",
  time: "time",
  value: 111,
}

describe("data table tests", () => {
  it('should contain static elements', () => {
    render(<DataTable data={[data]} />);
    expect(screen.getByText('Sender')).toBeInTheDocument()
    expect(screen.getByText('Time')).toBeInTheDocument()
    expect(screen.getByText("Value")).toBeInTheDocument();
  })

  it('should render table with one entry', () => {
    render(<DataTable data={[data]} />)
    const row = screen.getAllByTestId("test-table-row")
    expect(row).toHaveLength(1)
    const { getByText } = within(row[0])
    expect(getByText('sender')).toBeInTheDocument()
    expect(getByText('time')).toBeInTheDocument()
    expect(getByText("111")).toBeInTheDocument();
  })

  it("should render table with two entries", () => {
    render(<DataTable data={[data, data]} />);
    const row = screen.getAllByTestId("test-table-row");
    expect(row).toHaveLength(2);
  });
})
