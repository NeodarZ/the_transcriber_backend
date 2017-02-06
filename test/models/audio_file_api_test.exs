defmodule TheTranscriberBackend.AudioFileAPITest do
  use TheTranscriberBackend.ModelCase

  alias TheTranscriberBackend.AudioFileAPI

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = AudioFileAPI.changeset(%AudioFileAPI{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = AudioFileAPI.changeset(%AudioFileAPI{}, @invalid_attrs)
    refute changeset.valid?
  end
end
