defmodule OtapiWeb.OrganIntakeRequestValidatorService do

  def validate_organ_intake_request(params) do

    organ_intake_request = %{
      blood_type: Map.get(params, "blood_type") |> get_blood_type,
      body_size: Map.get(params, "body_size") |> get_body_size,
      name: Map.get(params, "name"),
      email: Map.get(params, "email")
    }

    if :error in Map.values(organ_intake_request) do
      {:error, "validation error"}
    else
      {:ok, organ_intake_request}
    end
  end

  defp get_blood_type(blood_type) do
    blood_types = ["A_Pos", "A_Neg", "B_Pos", "B_Neg", "AB_Pos", "AB_Neg", "O_Pos", "O_Neg"]
    if Enum.member?(blood_types, blood_type) do
      blood_type
    else
      :error
    end
  end

  defp get_body_size(body_size) do
    body_sizes = ["Infant", "Toddler", "Child", "Small_Female", "Small_Male", "Average_Female", "Average_Male", "Large_Female", "Large_Male"]
    if Enum.member?(body_sizes, body_size) do
      body_size
    else
      :error
    end
  end

end
