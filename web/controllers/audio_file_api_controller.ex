defmodule TheTranscriberBackend.AudioFileAPIController do
  use TheTranscriberBackend.Web, :controller

  alias TheTranscriberBackend.AudioFileAPI
  alias TheTranscriberBackend.AudioFile

  def index(conn, _params) do
    audio_file_api = Repo.all(AudioFile)
    render(conn, "index.json", audio_file_api: audio_file_api)
  end

  def create(conn, %{"audio_file" => %{"audio_duration" => audio_duration, "audio_path" => upload, "audio_name" => audio_name}}) do

    query = "select nextval('audio_file_id_seq')"
    result = Ecto.Adapters.SQL.query!(Repo, query, [])
    [[repo_last_id]] = result.rows # A beautiful pattern match :)

    path = "/media/phoenix_test/#{repo_last_id}_#{upload.filename}"
    File.cp(upload.path, path)

    changeset = AudioFile.changeset(%AudioFile{},
      %{audio_path: path,
        audio_name: audio_name,
        audio_duration: audio_duration})

          IO.inspect path

    case Repo.insert(changeset) do
      {:ok, audio_file_api} ->
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
    audio_file_api = Repo.get!(AudioFileAPI, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(audio_file_api)

    send_resp(conn, :no_content, "")
  end
end
