import React from "react";
import { render, screen, waitFor } from "@testing-library/react";
import App from "./App";

it("should render base components", async () => {
  render(<App />);
  await waitFor(() => {
    // if we don't do this, a strange warning appears
    const li = screen.getByText("Log In");
    expect(li).toBeInTheDocument();
  });
  const lo = screen.getByText("Log Out");
  expect(lo).toBeInTheDocument();
  const p = screen.getByTestId("test-profile");
  expect(p).toBeInTheDocument();
  const b = screen.getByTestId("test-sender-input");
  expect(b).toBeInTheDocument();
  const fbs = screen.getAllByTestId("test-fetch-button");
  expect(fbs.length).toBe(2);
  const dt = screen.getByTestId("test-data-table");
  expect(dt).toBeInTheDocument();
});
