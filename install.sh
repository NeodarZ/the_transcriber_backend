#!/bin/sh
mix ecto.migrate
mix run priv/repo/seeds.exs
