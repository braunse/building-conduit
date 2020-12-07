defmodule Conduit.Repo.Migrations.AddBlogFavoritedArticlesUsername do
  use Ecto.Migration

  def change do
    alter table(:blog_favorited_articles) do
      add :favorited_by_author_username, :text
    end
  end
end
