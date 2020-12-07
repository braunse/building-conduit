defmodule Conduit.Blog.ArticleTest do
  use Conduit.AggregateCase, aggregate: Conduit.Blog.Article

  alias Conduit.Blog.Article

  describe "publish article" do
    @tag :unit
    test "should succeed whan valid" do
      publish_article = build(:publish_article)

      with_events(publish_article, fn [%Article.Published{} = published] ->
        assert published.article_uuid == publish_article.article_uuid
        assert published.author_uuid == publish_article.author_uuid
        assert published.body == publish_article.body
        assert published.description == publish_article.description
        assert published.slug == publish_article.slug
        assert published.tag_list == publish_article.tag_list
        assert published.title == publish_article.title
      end)
    end
  end

  describe "favorite article" do
    @tag :unit
    test "should succeed when not already a favorite" do
      publish_article = build(:publish_article)
      favorite_article = build(:favorite_article, article_uuid: publish_article.article_uuid)

      with_events([publish_article, favorite_article], fn [%Article.Favorited{} = favorited] ->
        assert favorited.article_uuid == publish_article.article_uuid
        assert favorited.favorited_by_author_uuid != publish_article.author_uuid
        assert favorited.favorited_by_author_uuid == favorite_article.favorited_by_author_uuid
        assert favorited.favorite_count == 1
      end)
    end

    @tag :unit
    test "should do nothing when already a favorite" do
      publish_article = build(:publish_article)
      favorite_article = build(:favorite_article, article_uuid: publish_article.article_uuid)

      favorite_article_again =
        build(:favorite_article,
          article_uuid: publish_article.article_uuid,
          favorited_by_author_uuid: favorite_article.favorited_by_author_uuid
        )

      with_events([publish_article, favorite_article, favorite_article_again], fn list ->
        assert list == []
      end)
    end
  end

  describe "unfavorite article" do
    @tag :unit
    test "should do nothing when not already a favorite" do
      publish_article = build(:publish_article)
      unfavorite_article = build(:unfavorite_article, article_uuid: publish_article.article_uuid)

      with_events([publish_article, unfavorite_article], fn list ->
        assert [] = list
      end)
    end

    @tag :unit
    test "should succeed when already a favorite" do
      publish_article = build(:publish_article)
      favorite_article = build(:favorite_article, article_uuid: publish_article.article_uuid)

      unfavorite_article =
        build(:unfavorite_article,
          article_uuid: publish_article.article_uuid,
          unfavorited_by_author_uuid: favorite_article.favorited_by_author_uuid
        )

      with_events([publish_article, favorite_article, unfavorite_article], fn list ->
        assert [%Article.Unfavorited{} = e] = list
        assert e.article_uuid == publish_article.article_uuid
        assert e.favorite_count == 0
        assert e.unfavorited_by_author_uuid == favorite_article.favorited_by_author_uuid
      end)
    end
  end
end
