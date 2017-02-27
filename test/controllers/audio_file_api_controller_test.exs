defmodule TheTranscriberBackend.AudioFileAPIControllerTest do
  use TheTranscriberBackend.ConnCase

  alias TheTranscriberBackend.AudioFileAPI
  @valid_attrs %{}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, audio_file_api_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    audio_file_api = Repo.insert! %AudioFileAPI{}
    conn = get conn, audio_file_api_path(conn, :show, audio_file_api)
    assert json_response(conn, 200)["data"] == %{"id" => audio_file_api.id,
      "audio_path_id" => audio_file_api.audio_path_id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, audio_file_api_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, audio_file_api_path(conn, :create), audio_file_api: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(AudioFileAPI, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, audio_file_api_path(conn, :create), audio_file_api: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    audio_file_api = Repo.insert! %AudioFileAPI{}
    conn = put conn, audio_file_api_path(conn, :update, audio_file_api), audio_file_api: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(AudioFileAPI, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    audio_file_api = Repo.insert! %AudioFileAPI{}
    conn = put conn, audio_file_api_path(conn, :update, audio_file_api), audio_file_api: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    audio_file_api = Repo.insert! %AudioFileAPI{}
    conn = delete conn, audio_file_api_path(conn, :delete, audio_file_api)
    assert response(conn, 200)
    refute Repo.get(AudioFileAPI, audio_file_api.id)
  end
end
