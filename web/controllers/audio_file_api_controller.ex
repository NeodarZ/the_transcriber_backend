defmodule TheTranscriberBackend.AudioFileAPIController do
  use TheTranscriberBackend.Web, :controller

  alias TheTranscriberBackend.AudioFileAPI
  alias TheTranscriberBackend.AudioFile

  def index(conn, _params) do
    audio_file_api = Repo.all(AudioFile)
    render(conn, "index.json", audio_file_api: audio_file_api)
  end

  def create(conn, %{"audio_file" => %{"audio_duration" => audio_duration, "audio_path" => upload, "audio_name" => audio_name}}) do
    path = "/media/phoenix_test/"

    changeset = AudioFile.changeset(%AudioFile{},
      %{audio_path: upload.filename,
        audio_name: audio_name,
        audio_duration: "#{FFprobe.duration(upload.path)}"})

    case Repo.insert(changeset) do
      {:ok, audio_file_api} ->
        File.cp(upload.path, "#{path}#{audio_file_api.id}_#{upload.filename}")

        conn
        |> put_status(:created)
        |> put_resp_header("location", audio_file_api_path(conn, :show, audio_file_api))
        |> render("show.json", audio_file_api: audio_file_api)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(TheTranscriberBackend.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    audio_file_api = Repo.get!(AudioFileAPI, id)
    render(conn, "show.json", audio_file_api: audio_file_api)
  end

  def update(conn, %{"id" => id, "audio_file_api" => audio_file_api_params}) do
    audio_file_api = Repo.get!(AudioFileAPI, id)
    changeset = AudioFileAPI.changeset(audio_file_api, audio_file_api_params)

    case Repo.update(changeset) do
      {:ok, audio_file_api} ->
        render(conn, "show.json", audio_file_api: audio_file_api)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(TheTranscriberBackend.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    path = "/media/phoenix_test/"
    audio_file_api = Repo.get!(AudioFileAPI, id)
    cond do
      audio_file_api !=nil ->
        # Here we use delete! (with a bang) because we expect
        # it to always work (and if it does not, it will raise).
        File.rm("#{path}#{audio_file_api.id}_#{audio_file_api.audio_path}")
        Repo.delete!(audio_file_api)

        conn
        |> send_resp(200, "Audio file deleted successfully.")
      audio_file_api == nil ->
        conn
        |> send_resp(404, "File not found in database !")
    end
  end
end
