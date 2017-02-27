# TheTranscriberBackend

To start your Phoenix app:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `npm install`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please
[check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix

## Usage of the api:

To upload a file:

`curl --form "audio_file[audio_path]=@RapportAssemblee.mp4" --form "audio_file[audio_name]=Rapport vidéo de l'assemblée" --form "audio_file[audio_duration]=03:20"  http://127.0.0.1:4000/api/audio_file`

To update a file:

`curl --form "audio_file[audio_path]=@RapportAssemblee.mp4" --form "audio_file[audio_name]=RapportAssemblee.mp4" --form "audio_file[audio_duration]=00:00" -X PATCH http://127.0.0.1:4000/audio_file/42`

To delete a file:

`curl -X DELETE http://127.0.0.1:4000/api/audio_file/42`

You can also view the content of the database with this web page :
[`localhost:4000/audio_file`](http://127.0.0.1:4000/audio_file)

## Development:
If you have an error like : `[debug] ** (Ecto.NoResultsError) expected at least one result but got none in query:` when you dev, check the doc :
[`http://www.phoenixframework.org/v0.14.0/docs/custom-errors`](http://www.phoenixframework.org/v0.14.0/docs/custom-errors)

tl;dr: change this `debug_errors: false` and `catch_errors: true` in
`config/dev.exs`
