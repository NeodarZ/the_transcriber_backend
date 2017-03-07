defmodule TheTranscriberBackend.AudioFileAPI do
  use TheTranscriberBackend.Web, :model

  #schema "audio_file_api" do
    #belongs_to :audio_path, TheTranscriberBackend.AudioPath

  schema "audio_file" do
    field :audio_path, :string
    field :audio_name, :string
    field :audio_duration, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:audio_path, :audio_name, :audio_duration])
    |> validate_required([:audio_path, :audio_name, :audio_duration])
  end
end
