defmodule BlogrWeb.PostView do
  use BlogrWeb, :view

  alias Blogr.Blog.Tag

  def tags_input(form) do
    tags_string = form
                 |> input_value(:tags)
                 |> Enum.map(&tag_to_string/1)
                 |> Enum.join(", ")

    text_input(form, :tags, value: tags_string)
  end

  def tag_to_string(%Ecto.Changeset{} = tag) do
    Ecto.Changeset.get_field(tag, :name)
  end

  def tag_to_string(%Tag{} = tag) do
    tag.name
  end
end
