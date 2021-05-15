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

  test "/organ-intake-request stores well-formed data in Redis" do
    # todo: this should go in an integration test, mock Redix for the unit test
    Redix.command!(:redix, ["DEL", "organ_intake_requests"])

    json_body = %{
      "blood_type" => "B_Pos",
      "body_size" => "Average_Male",
      "name" => "Tim Apple",
      "email" => "tim@apple.com"
    }

    build_conn()
      |> put_req_header("content-type", "application/json")
      |> post("/api/organ-intake-requests", Poison.encode!(json_body))

    assert Redix.command!(:redix, ["RPOP", "organ_intake_requests"]) |> Poison.decode! == json_body
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
