defmodule GothamapiWeb.WorkingtimesView do
  use GothamapiWeb, :view
  alias GothamapiWeb.WorkingtimesView

  def render("index.json", %{worktimes: worktimes}) do
    %{data: render_many(worktimes, WorkingtimesView, "workingtimes.json")}
  end

  def render("show.json", %{workingtimes: workingtimes}) do
    %{data: render_one(workingtimes, WorkingtimesView, "workingtimes.json")}
  end

  def render("workingtimes.json", %{workingtimes: workingtimes}) do
    %{
      id: workingtimes.id,
      start: workingtimes.start,
      end: workingtimes.end
    }
  end
end
