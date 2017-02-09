defmodule TheTranscriberBackend.Repo.Migrations.CreateAudioFile do
  use Ecto.Migration

  def change do
    create table(:audio_file) do
      add :audio_path, :string
      add :audio_name, :string
      add :audio_duration, :string

      timestamps()
    end

  end
end
