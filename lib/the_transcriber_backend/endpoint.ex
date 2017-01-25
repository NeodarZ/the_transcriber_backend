defmodule TheTranscriberBackend.Endpoint do
  use Phoenix.Endpoint, otp_app: :the_transcriber_backend

  socket "/socket", TheTranscriberBackend.UserSocket

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phoenix.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/", from: :the_transcriber_backend, gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt),
    at: "/uploads", from: "/media"


  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json, :length],
    pass: ["*/*"],
    json_decoder: Poison,
    length: 80_000_000

  plug Plug.MethodOverride
  plug Plug.Head

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session,
    store: :cookie,
    key: "_the_transcriber_backend_key",
    signing_salt: "xC0393Y5"

  plug TheTranscriberBackend.Router
end
