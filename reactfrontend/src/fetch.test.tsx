import React from "react";
import { render, screen } from "@testing-library/react";
import FetchButton from "./fetch";

it("should render button", () => {
  render(<FetchButton host="localhost" port="4000" cb={(msg) => {}} />)
  const buttonElement = screen.getByText("Fetch localhost:4000");
  expect(buttonElement).toBeInTheDocument();
})