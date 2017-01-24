defmodule TheTranscriberBackend.AudioFileControllerTest do
  use TheTranscriberBackend.ConnCase

  alias TheTranscriberBackend.AudioFile
  @valid_attrs %{audio_duration: "some content", audio_path: "some content", transcription_file_path: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, audio_file_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing audio file"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, audio_file_path(conn, :new)
    assert html_response(conn, 200) =~ "New audio file"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, audio_file_path(conn, :create), audio_file: @valid_attrs
    assert redirected_to(conn) == audio_file_path(conn, :index)
    assert Repo.get_by(AudioFile, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, audio_file_path(conn, :create), audio_file: @invalid_attrs
    assert html_response(conn, 200) =~ "New audio file"
  end

  test "shows chosen resource", %{conn: conn} do
    audio_file = Repo.insert! %AudioFile{}
    conn = get conn, audio_file_path(conn, :show, audio_file)
    assert html_response(conn, 200) =~ "Show audio file"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, audio_file_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    audio_file = Repo.insert! %AudioFile{}
    conn = get conn, audio_file_path(conn, :edit, audio_file)
    assert html_response(conn, 200) =~ "Edit audio file"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    audio_file = Repo.insert! %AudioFile{}
    conn = put conn, audio_file_path(conn, :update, audio_file), audio_file: @valid_attrs
    assert redirected_to(conn) == audio_file_path(conn, :show, audio_file)
    assert Repo.get_by(AudioFile, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    audio_file = Repo.insert! %AudioFile{}
    conn = put conn, audio_file_path(conn, :update, audio_file), audio_file: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit audio file"
  end

  test "deletes chosen resource", %{conn: conn} do
    audio_file = Repo.insert! %AudioFile{}
    conn = delete conn, audio_file_path(conn, :delete, audio_file)
    assert redirected_to(conn) == audio_file_path(conn, :index)
    refute Repo.get(AudioFile, audio_file.id)
  end
end
