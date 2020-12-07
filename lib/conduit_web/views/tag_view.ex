defmodule ConduitWeb.TagView do
  use ConduitWeb, :view

  def render("index.json", %{tag_names: tag_names}) do
    %{
      tags: tag_names
    }
  end
end
