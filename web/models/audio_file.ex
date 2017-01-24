defmodule TheTranscriberBackend.AudioFile do
  use TheTranscriberBackend.Web, :model

  schema "audio_file" do
    field :audio_path, :string
    field :transcription_file_path, :string
    field :audio_duration, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:audio_path, :transcription_file_path, :audio_duration])
    |> validate_required([:audio_path, :transcription_file_path, :audio_duration])
  end
end
