defmodule Blogr.Blog.PostTag do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts_tags" do
    field :post_id, :id
    field :tag_id, :id

    timestamps()
  end

  @doc false
  def changeset(post_tag, attrs) do
    post_tag
    |> cast(attrs, [])
    |> validate_required([])
  end
end
