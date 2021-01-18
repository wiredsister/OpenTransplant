defmodule OtapiWeb.OrganIntakeRequestController do
  use OtapiWeb, :controller

  def create(conn, params) do
    case OtapiWeb.OrganIntakeRequestValidatorService.validate_organ_intake_request(params) do
      {:ok, organ_intake_request} ->
        store_in_redis(organ_intake_request)
        conn |> send_resp(201, "Created")
      {:error, error} ->
        IO.puts(error)
        conn |> send_resp(400, "Bad Request")
      _ ->
        conn |> send_resp(500, "Internal Server Error")
    end
  end

  defp store_in_redis(message) do
    case Redix.command(:redix, ["LPUSH", "organ_intake_requests", Poison.encode!(message)]) do
      {:ok, _} -> IO.puts("success")
      {:error, e} -> IO.inspect(e)
    end
  end
end
