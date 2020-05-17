defmodule Blogr.Blog do
  @moduledoc """
  The Blog context.
  """

  import Ecto.Query, warn: false
  alias Blogr.Repo
  alias Ecto.Multi

  alias Blogr.Blog.{Post, Tag}

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts do
    Repo.all(Post)
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id), do: Repo.get!(Post, id)

  def get_post_with_tags!(id), do: Post |> preload(:tags) |> Repo.get!(id)

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(attrs \\ %{}) do
    create_or_update_post(%Post{}, attrs)
  end

  defp create_or_update_post(post, attrs) do
    Multi.new()
    |> ensure_tags(attrs["tags"])
    |> Multi.run(:post, fn repo, %{find_tags: tags} ->
      post
      |> Post.changeset(attrs)
      |> Ecto.Changeset.put_assoc(:tags, tags)
      |> repo.insert()
    end)
    |> Repo.transaction
  end

  defp ensure_tags(multi, tags) do
    now = NaiveDateTime.utc_now |> NaiveDateTime.truncate(:second)
    tags =
      tags
      |> to_string
      |> String.split(",")
      |> Enum.map(fn tag -> String.trim(tag) end)
      |> Enum.reject(fn tag -> tag == "" end)
      |> Enum.map(fn tag_name ->
        %{name: tag_name, inserted_at: now, updated_at: now}
      end)

    multi
    |> Multi.insert_all(:insert_tags, Tag, tags, on_conflict: :nothing)
    |> Multi.run(:find_tags, fn repo, _ ->
      tag_names = Enum.map(tags, & &1.name )
      {:ok, repo.all(from t in Tag, where: t.name in ^tag_names)}
    end)
  end


  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs) do
    create_or_update_post(post, attrs)
  end

  @doc """
  Deletes a post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{data: %Post{}}

  """
  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end

  alias Blogr.Blog.Tag

  @doc """
  Returns the list of tags.

  ## Examples

      iex> list_tags()
      [%Tag{}, ...]

  """
  def list_tags do
    Repo.all(Tag)
  end

  @doc """
  Gets a single tag.

  Raises `Ecto.NoResultsError` if the Tag does not exist.

  ## Examples

      iex> get_tag!(123)
      %Tag{}

      iex> get_tag!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tag!(id), do: Repo.get!(Tag, id)

  @doc """
  Updates a tag.

  ## Examples

      iex> update_tag(tag, %{field: new_value})
      {:ok, %Tag{}}

      iex> update_tag(tag, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tag(%Tag{} = tag, attrs) do
    tag
    |> Tag.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a tag.

  ## Examples

      iex> delete_tag(tag)
      {:ok, %Tag{}}

      iex> delete_tag(tag)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tag(%Tag{} = tag) do
    Repo.delete(tag)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tag changes.

  ## Examples

      iex> change_tag(tag)
      %Ecto.Changeset{data: %Tag{}}

  """
  def change_tag(%Tag{} = tag, attrs \\ %{}) do
    Tag.changeset(tag, attrs)
  end
end
