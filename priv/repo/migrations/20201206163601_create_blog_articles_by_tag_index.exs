defmodule Conduit.Repo.Migrations.CreateBlogArticlesByTagIndex do
  use Ecto.Migration

  def change do
    create index(:blog_articles, [:tag_list], using: "GIN")
  end
end
