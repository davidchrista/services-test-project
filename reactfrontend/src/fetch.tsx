import { useAuth0 } from "@auth0/auth0-react";
import axios from "axios";
import React from "react";

export interface Data {
  sender: string;
  time: string;
  value: number;
}

export interface FetchButtonData {
  host: string;
  port: string;
  path?: string;
  cb: (msg: Data[]) => void;
}

const FetchButton = (data: FetchButtonData) => {
  const { getAccessTokenSilently } = useAuth0();

  const doFetch = async () => {
    try {
      const address = `http://${data.host}:${data.port}`;

      const accessToken = await getAccessTokenSilently({
        audience: "http://localhost:4000",
      });

      const response = await axios.get(
        address + (data.path !== undefined ? "/" + data.path : ""),
        {
          headers: {
            Authorization: `Bearer ${accessToken}`,
          },
        }
      );

      const text = await response.data;

      data.cb(text);
    } catch (e: any) {
      data.cb([]);
    }
  };

  return (
    <button onClick={doFetch}>
      Fetch {data.host}:{data.port}
    </button>
  );
};

export default FetchButton;
