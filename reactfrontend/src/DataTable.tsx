import React from "react";
import { Data } from "./fetch";
import "./DataTable.css";

interface DataTableData {
  data: Data[];
}

const DataTable = ({ data }: DataTableData) => {
  return (
    <table data-testid="test-data-table" className="custom-table" width={1000}>
      <thead>
        <tr>
          <th>Sender</th>
          <th>Time</th>
          <th>Value</th>
        </tr>
      </thead>
      <tbody>
        {data.map((item, index) => (
          <tr data-testid="test-table-row" key={index}>
            <td>{item.sender}</td>
            <td>{item.time}</td>
            <td>{item.value}</td>
          </tr>
        ))}
      </tbody>
    </table>
  );
};

export default DataTable;
