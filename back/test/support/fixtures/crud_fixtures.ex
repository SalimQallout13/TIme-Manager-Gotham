defmodule Gothamapi.CrudFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Gothamapi.Crud` context.
  """

  @doc """
  Generate a users.
  """
  def users_fixture(attrs \\ %{}) do
    {:ok, users} =
      attrs
      |> Enum.into(%{
        email: "some email",
        username: "some username"
      })
      |> Gothamapi.Crud.create_users()

    users
  end

  @doc """
  Generate a clocks.
  """
  def clocks_fixture(attrs \\ %{}) do
    {:ok, clocks} =
      attrs
      |> Enum.into(%{
        status: true,
        time: ~N[2021-10-26 16:19:00]
      })
      |> Gothamapi.Crud.create_clocks()

    clocks
  end

  @doc """
  Generate a workingtimes.
  """
  def workingtimes_fixture(attrs \\ %{}) do
    {:ok, workingtimes} =
      attrs
      |> Enum.into(%{
        end: ~N[2021-10-26 16:19:00],
        start: ~N[2021-10-26 16:19:00]
      })
      |> Gothamapi.Crud.create_workingtimes()

    workingtimes
  end
end
