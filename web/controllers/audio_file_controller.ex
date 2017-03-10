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
    path = "/media/phoenix_test/"

    changeset = AudioFile.changeset(%AudioFile{},
      %{audio_path: upload.filename,
        audio_name: audio_name,
        audio_duration: audio_duration})

    case Repo.insert(changeset) do
      {:ok, audio_file} ->
        File.cp(upload.path, "#{path}#{audio_file.id}_#{upload.filename}")
        System.cmd "notify-send", ["Yeah ! Your file is uploaded !"]
        conn
        |> put_status(:created)
        |> put_resp_header("location", audio_file_path(conn, :show, audio_file))
        |> render("show.html", audio_file: audio_file)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(TheTranscriberBackend.ChangesetView, "error.html", changeset: changeset)
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
    path = "/media/phoenix_test/"
    audio_file = Repo.get(AudioFile, id)
    quey = from the_audio_file in AudioFile, where: [id: ^id]
    cond do
      audio_file !=nil ->
        # Here we use delete! (with a bang) because we expect
        # it to always work (and if it does not, it will raise).
        File.rm("#{path}#{audio_file.id}_#{audio_file.audio_path}")
        Repo.delete!(audio_file)

        conn
        |> put_flash(:info, "Audio file deleted successfully.")
        |> redirect(to: audio_file_path(conn, :index))
      audio_file == nil ->
        conn
        |> put_flash(:info, "File not found in database !")
        |> redirect(to: audio_file_path(conn, :index))
    end
  end
end
