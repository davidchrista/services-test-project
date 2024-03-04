import React, { useState } from "react";
import "./App.css";
import Profile from "./profile";
import LoginButton from "./login";
import LogoutButton from "./logout";
import FetchButton, { Data } from "./fetch";
import DataTable from "./DataTable";

function App() {
  const [senderInput, setSenderInput] = useState<string | undefined>(undefined);
  const [fetchResult, setFetchResult] = useState<Data[]>([]);

  return (
    <>
      <LoginButton />
      <LogoutButton />
      <Profile />
      <input
        type="text"
        value={senderInput}
        onChange={(event) => {
          event.preventDefault();
          setSenderInput(event.target.value);
        }}
      />
      <FetchButton
        host="localhost"
        port="4000"
        path={senderInput !== "" ? senderInput : undefined}
        cb={setFetchResult}
      />
      <FetchButton
        host="localhost"
        port="4200"
        path={senderInput !== "" ? senderInput : undefined}
        cb={setFetchResult}
      />
      <DataTable data={fetchResult} />
    </>
  );
}

export default App;
