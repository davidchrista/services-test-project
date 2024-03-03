import React from "react";
import { Data } from "./fetch";
import "./DataTable.css";

interface DataTableData {
  data: Data[];
}

const DataTable = ({ data }: DataTableData) => {
  return (
    <table className="custom-table" width={1000}>
      <thead>
        <tr>
          <th>Sender</th>
          <th>Time</th>
          <th>Value</th>
        </tr>
      </thead>
      <tbody>
        {data.map((item, index) => (
          <tr key={index}>
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
