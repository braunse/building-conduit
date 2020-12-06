defmodule Conduit.Blog.Article do
  defstruct [
    :uuid,
    :slug,
    :title,
    :description,
    :body,
    :tag_list,
    :author_uuid
  ]

  alias Conduit.Blog.Article

  def execute(%Article{uuid: nil} = _new, %Article.Publish{} = publish) do
    %Article.Published{
      article_uuid: publish.article_uuid,
      slug: publish.slug,
      title: publish.title,
      description: publish.description,
      body: publish.body,
      tag_list: publish.tag_list,
      author_uuid: publish.author_uuid
    }
  end

  def apply(%Article{} = it, %Article.Published{} = published) do
    %Article{
      it
      | uuid: published.article_uuid,
        slug: published.slug,
        title: published.title,
        description: published.description,
        body: published.body,
        tag_list: published.tag_list,
        author_uuid: published.author_uuid
    }
  end
end
