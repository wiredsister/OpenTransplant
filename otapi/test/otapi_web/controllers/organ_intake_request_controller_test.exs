defmodule OtapiWeb.OrganIntakeRequestControllerTest do
  use OtapiWeb.ConnCase

  test "/organ-intake-request returns 201 for well-formed data" do
    json_body = %{
      blood_type: "A_Pos",
      body_size: "Infant"
    }

    conn = build_conn()
      |> put_req_header("content-type", "application/json")
      |> post("/api/organ-intake-requests", Poison.encode!(json_body))

    assert conn.status == 201
  end

  test "/organ-intake-request returns 400 for malformed data" do
    json_body = %{
      blood_type: "A_Pxs",
      body_size: "Infant"
    }

    conn = build_conn()
      |> put_req_header("content-type", "application/json")
      |> post("/api/organ-intake-requests", Poison.encode!(json_body))

    assert conn.status == 400
  end
end
