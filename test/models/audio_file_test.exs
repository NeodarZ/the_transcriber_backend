defmodule TheTranscriberBackend.AudioFileTest do
  use TheTranscriberBackend.ModelCase

  alias TheTranscriberBackend.AudioFile

  @valid_attrs %{audio_duration: "some content", audio_path: "some content", audio_name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = AudioFile.changeset(%AudioFile{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = AudioFile.changeset(%AudioFile{}, @invalid_attrs)
    refute changeset.valid?
  end
end
