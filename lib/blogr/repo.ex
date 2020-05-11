defmodule Blogr.Repo do
  use Ecto.Repo,
    otp_app: :blogr,
    adapter: Ecto.Adapters.Postgres
end
