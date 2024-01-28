import { useAuth0 } from "@auth0/auth0-react";
import React, { useEffect, useState } from "react";

const Profile = () => {
  const { user, isAuthenticated, isLoading, getAccessTokenSilently  } = useAuth0();

  const [token, setToken] = useState<string>('');

  useEffect(() => {
    getAccessTokenSilently().then((t) => {
      setToken(t);
    });
  }, [isAuthenticated, getAccessTokenSilently]);

  if (isLoading) {
    return <div>Loading ...</div>;
  }

  return (
    (isAuthenticated && user !== undefined && (
      <div>
        <img src={user.picture} alt={user.name} />
        <h2>{user.name}</h2>
        <p>{user.email}</p>
        <p>{token}</p>
      </div>
    )) || <></>
  );
};

export default Profile;