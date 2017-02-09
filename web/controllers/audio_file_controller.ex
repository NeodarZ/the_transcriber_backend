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

    repo_last_id = Repo.one(from x in AudioFile, order_by: [desc: x.id], limit: 1)

    #query = "select nextval('audio_file_id_seq')"

    #result = Ecto.Adapters.SQL.query!(Repo, query, [])

    #[[repo_last_id]] = result.rows # A beautiful pattern match :)

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
