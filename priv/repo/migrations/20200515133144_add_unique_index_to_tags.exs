defmodule Blogr.Repo.Migrations.AddUniqueIndexToTags do
  use Ecto.Migration

  def change do
    execute "TRUNCATE tags CASCADE"
    create index("tags", [:name], unique: true)
  end
end
