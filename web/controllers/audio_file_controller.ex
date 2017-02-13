defmodule TheTranscriberBackend.AudioFileController do
  use TheTranscriberBackend.Web, :controller

  alias TheTranscriberBackend.AudioFile

  def index(conn, _params) do
    audio_file = Repo.all(AudioFile)
    render(conn, "index.html", audio_file: audio_file)
  end

  def new(conn, _params) do
    changeset = AudioFile.changeset(%AudioFile{})
    render(conn, "new.html", changeset: changeset)
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

    path = "/media/phoenix_test/#{repo_last_id}_#{upload.filename}"
    File.cp(upload.path, path)

    changeset = AudioFile.changeset(%AudioFile{},
      %{audio_path: path,
        audio_name: audio_name,
        audio_duration: audio_duration})

    case Repo.insert(changeset) do
      {:ok, _audio_file} ->
        conn
        |> put_flash(:info, "Audio file uploaded successfully.")
        |> redirect(to: audio_file_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end



#  def create(conn, %{"audio_file" => %{"audio_duration" => audio_duration, "audio_name" => audio_name}}) do
#
#    ## Do something here if no file has been uploaded
#  end

  def show(conn, %{"id" => id}) do
    audio_file = Repo.get!(AudioFile, id)
    render(conn, "show.html", audio_file: audio_file)
  end

  def edit(conn, %{"id" => id}) do
    audio_file = Repo.get!(AudioFile, id)
    changeset = AudioFile.changeset(audio_file)
    render(conn, "edit.html", audio_file: audio_file, changeset: changeset)
  end

  def update(conn, %{"id" => id, "audio_file" => %{"audio_duration" => audio_duration, "audio_path" => upload, "audio_name" => audio_name}}) do

    path = "/media/phoenix_test/#{id}_#{upload.filename}"

    File.cp(upload.path, path)

    audio_file = Repo.get!(AudioFile, id)
    #changeset = AudioFile.changeset(audio_file, audio_file_params)

    changeset = AudioFile.changeset(audio_file,
      %{audio_path: path,
        audio_name: audio_name,
        audio_duration: audio_duration})

    case Repo.update(changeset) do
      {:ok, audio_file} ->
        conn
        |> put_flash(:info, "Audio file updated successfully.")
        |> redirect(to: audio_file_path(conn, :show, audio_file))
      {:error, changeset} ->
        render(conn, "edit.html", audio_file: audio_file, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    audio_file = Repo.get!(AudioFile, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    File.rm(audio_file.audio_path)
    Repo.delete!(audio_file)

    conn
    |> put_flash(:info, "Audio file deleted successfully.")
    |> redirect(to: audio_file_path(conn, :index))
  end
end
