defmodule Conduit.Blog.Article.Projection do
  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: false}

  schema "blog_articles" do
    field :slug, :string
    field :title, :string
    field :description, :string
    field :body, :string
    field :tag_list, {:array, :string}
    field :favorite_count, :integer
    field :published_at, :naive_datetime_usec
    field :author_uuid, :binary_id
    field :author_username, :string
    field :author_bio, :string
    field :author_image, :string

    timestamps()
  end
end
