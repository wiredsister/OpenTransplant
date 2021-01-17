defmodule OtapiWeb.OrganIntakeRequestController do
  use OtapiWeb, :controller

  def create(conn, params) do
    case OtapiWeb.OrganIntakeRequestValidator.validate_organ_intake_request(params) do
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

defmodule OtapiWeb.OrganIntakeRequestValidator do

  def validate_organ_intake_request(params) do

    organ_intake_request = %{
      blood_type: Map.get(params, "blood_type") |> OtapiWeb.OrganIntakeRequestValidator.get_blood_type,
      body_size: Map.get(params, "body_size") |> OtapiWeb.OrganIntakeRequestValidator.get_body_size,
      name: Map.get(params, "name"),
      email: Map.get(params, "email")
    }

    if :error in Map.values(organ_intake_request) do
      {:error, "validation error"}
    else
      {:ok, organ_intake_request}
    end
  end

  def get_blood_type(blood_type) do
    blood_types = ["A_Pos", "A_Neg", "B_Pos", "B_Neg", "AB_Pos", "AB_Neg", "O_Pos", "O_Neg"]
    if Enum.member?(blood_types, blood_type) do
      blood_type
    else
      :error
    end
  end

  def get_body_size(body_size) do
    body_sizes = ["Infant", "Toddler", "Child", "Small_Female", "Small_Male", "Average_Female", "Average_Male", "Large_Female", "Large_Male"]
    if Enum.member?(body_sizes, body_size) do
      body_size
    else
      :error
    end
  end

end
