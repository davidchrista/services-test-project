import { useAuth0 } from "@auth0/auth0-react";
import axios from "axios";
import React from "react";

interface FetchButtonData {
  host: string;
  port: string;
  cb: (msg: string) => void
}

const FetchButton = (data: FetchButtonData) => {
  const { getAccessTokenSilently } = useAuth0();

  const doFetch = async () => {
    try {
      const address = `http://${data.host}:${data.port}`;

      const accessToken = await getAccessTokenSilently({
        audience: 'http://localhost:4000'
      });  
      
      const response = await axios.get(address, {
        headers: {
          Authorization: `Bearer ${accessToken}`
        }
      });

      const text = await response.data;

      data.cb(text);
    } catch (e: any) {
      data.cb(`Error: ${e.message}`);
    }
  };

  return <button onClick={doFetch}>Fetch {data.host}:{data.port}</button>;
};

export default FetchButton;