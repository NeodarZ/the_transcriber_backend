defmodule TheTranscriberBackend.AudioFileAPIView do
  use TheTranscriberBackend.Web, :view



  def render("index.json", %{audio_file_api: audio_file_api}) do
    %{data: render_many(audio_file_api, TheTranscriberBackend.AudioFileAPIView, "audio_file_api.json")}
  end

  def render("show.json", %{audio_file_api: audio_file_api}) do
    %{data: render_one(audio_file_api, TheTranscriberBackend.AudioFileAPIView, "audio_file_api.json")}
  end

  def render("audio_file_api.json", %{audio_file_api: audio_file_api}) do
    %{id: audio_file_api.id,
      audio_path: audio_file_api.audio_path,
      audio_name: audio_file_api.audio_name,
      audio_duration: audio_file_api.audio_duration}
  end
end
