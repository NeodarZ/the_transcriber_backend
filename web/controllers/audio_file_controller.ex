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

  def create(conn, %{"audio_file" => audio_file_params}) do
    if upload = audio_file_params["audio_path"] do
      extension = Path.extname(upload.filename)
      path = "/media/phoenix_test/#{upload.filename}"
      File.cp(upload.path, path)
    end
    changeset = AudioFile.changeset(%AudioFile{}, audio_file_params)
                |> Ecto.Changeset.put_change(:audio_path, path)
    IO.inspect changeset 

    case Repo.insert(changeset) do
      {:ok, _audio_file} ->
        conn
        |> put_flash(:info, "Audio file uploaded successfully.")
        |> redirect(to: audio_file_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    audio_file = Repo.get!(AudioFile, id)
    render(conn, "show.html", audio_file: audio_file)
  end

  def edit(conn, %{"id" => id}) do
    audio_file = Repo.get!(AudioFile, id)
    changeset = AudioFile.changeset(audio_file)
    render(conn, "edit.html", audio_file: audio_file, changeset: changeset)
  end

  def update(conn, %{"id" => id, "audio_file" => audio_file_params}) do
    audio_file = Repo.get!(AudioFile, id)
    changeset = AudioFile.changeset(audio_file, audio_file_params)

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
