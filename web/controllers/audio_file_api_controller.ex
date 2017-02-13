defmodule TheTranscriberBackend.AudioFileAPIController do
  use TheTranscriberBackend.Web, :controller

  alias TheTranscriberBackend.AudioFileAPI
  alias TheTranscriberBackend.AudioFile

  def index(conn, _params) do
    audio_file_api = Repo.all(AudioFile)
    render(conn, "index.json", audio_file_api: audio_file_api)
  end

  def create(conn, %{"audio_file" => %{"audio_duration" => audio_duration, "audio_path" => upload, "audio_name" => audio_name}}) do

    query_table_is_empty = "select * from audio_file;"
    result_table_is_empty = Ecto.Adapters.SQL.query!(Repo, query_table_is_empty, [])
    result_table_is_empty_rows = result_table_is_empty.rows
    case [] do
        ^result_table_is_empty_rows ->
          repo_last_id = 1

          # Don't ask why, but it would seem that you must select nextval
          # BEFORE currval... Yes ! Seriously...
          query_nextval = "select nextval('audio_file_id_seq');"
          result_nextval = Ecto.Adapters.SQL.query!(Repo, query_nextval, [])

          query_setval = "select setval('audio_file_id_seq', 1);"
          result_setval = Ecto.Adapters.SQL.query!(Repo, query_setval, [])

          query_currval= "select currval('audio_file_id_seq');"
          result_currval = Ecto.Adapters.SQL.query!(Repo, query_currval, [])

        _ ->
          query_currval = "select max(id) from audio_file;"
          result_currval = Ecto.Adapters.SQL.query!(Repo, query_currval, [])
          [[repo_last_id]] = result_currval.rows # A beautiful pattern match :)
    end

    path = "/media/phoenix_test/#{repo_last_id + 1}_#{upload.filename}"
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
