import React, { useState } from "react";
import "./App.css";
import Profile from "./profile";
import LoginButton from "./login";
import LogoutButton from "./logout";
import FetchButton, { Data } from "./fetch";
import DataTable from "./DataTable";

function App() {
  const [fetchResult, setFetchResult] = useState<Data[]>([]);

  return (
    <>
      <LoginButton />
      <LogoutButton />
      <FetchButton host="localhost" port="4000" cb={setFetchResult} />
      <FetchButton host="localhost" port="4200" cb={setFetchResult} />
      <Profile />
      <DataTable data={fetchResult} />
    </>
  );
}

export default App;
