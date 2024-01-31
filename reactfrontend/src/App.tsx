import React, { useState } from "react";
import "./App.css";
import Profile from "./profile";
import LoginButton from "./login";
import LogoutButton from "./logout";
import FetchButton from "./fetch";

function App() {
  const [fetchResult, setFetchResult] = useState<string>("");

  return (
    <>
      <LoginButton />
      <LogoutButton />
      <FetchButton host="localhost" port="4000" cb={setFetchResult} />
      <FetchButton host="localhost" port="4100" cb={setFetchResult} />
      <FetchButton host="localhost" port="4200" cb={setFetchResult} />
      <Profile />
      <div>
        <p>{fetchResult}</p>
      </div>
    </>
  );
}

export default App;
