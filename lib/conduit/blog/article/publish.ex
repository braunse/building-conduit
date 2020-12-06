defmodule Conduit.Blog.Article.Publish do
  defstruct article_uuid: "",
            author_uuid: "",
            slug: "",
            title: "",
            description: "",
            body: "",
            tag_list: []

  use ExConstructor
  use Vex.Struct

  alias Conduit.Blog.Author
  alias Conduit.Blog.Article

  validates :article_uuid, uuid: true
  validates :author_uuid, uuid: true

  validates :slug,
    presence: [message: "can't be empty"],
    format: [
      with: ~r/^[a-zA-Z0-9\-]+$/,
      allow_nil: true,
      allow_blank: true,
      message: "is invalid"
    ],
    string: true,
    unique_article_slug: true

  validates :title, presence: [message: "can't be empty"], string: true
  validates :description, presence: [message: "can't be empty"], string: true
  validates :body, presence: [message: "can't be empty"], string: true
  validates :tag_list, by: &is_list/1

  def assign_uuid(%__MODULE__{} = it, uuid) do
    %__MODULE__{it | article_uuid: uuid}
  end

  def assign_author(%__MODULE__{} = it, %Author.AuthorProjection{} = author) do
    %__MODULE__{it | author_uuid: author.uuid}
  end

  def generate_url_slug(%__MODULE__{title: title} = it) do
    with {:ok, slug} <- Article.Slugger.slugify(title) do
      %__MODULE__{it | slug: slug}
    else
      _ -> it
    end
  end

  defimpl Conduit.Support.Middleware.Uniqueness.UniqueFields, for: __MODULE__ do
    alias Conduit.Support.Middleware.Uniqueness.Claim

    def unique_fields(_command) do
      [
        %Claim{
          context: Article.Publish,
          value: :slug,
          field: :slug,
          validation: :unique_article_slug,
          message: "has already been taken"
        }
      ]
    end
  end
end
