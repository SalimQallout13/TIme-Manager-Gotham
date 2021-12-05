defmodule Gothamapi.CrudTest do
  use Gothamapi.DataCase

  alias Gothamapi.Crud

  describe "users" do
    alias Gothamapi.Crud.Users

    import Gothamapi.CrudFixtures

    @invalid_attrs %{email: nil, username: nil}

    test "list_users/0 returns all users" do
      users = users_fixture()
      assert Crud.list_users() == [users]
    end

    test "get_users!/1 returns the users with given id" do
      users = users_fixture()
      assert Crud.get_users!(users.id) == users
    end

    test "create_users/1 with valid data creates a users" do
      valid_attrs = %{email: "some email", username: "some username"}

      assert {:ok, %Users{} = users} = Crud.create_users(valid_attrs)
      assert users.email == "some email"
      assert users.username == "some username"
    end

    test "create_users/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Crud.create_users(@invalid_attrs)
    end

    test "update_users/2 with valid data updates the users" do
      users = users_fixture()
      update_attrs = %{email: "some updated email", username: "some updated username"}

      assert {:ok, %Users{} = users} = Crud.update_users(users, update_attrs)
      assert users.email == "some updated email"
      assert users.username == "some updated username"
    end

    test "update_users/2 with invalid data returns error changeset" do
      users = users_fixture()
      assert {:error, %Ecto.Changeset{}} = Crud.update_users(users, @invalid_attrs)
      assert users == Crud.get_users!(users.id)
    end

    test "delete_users/1 deletes the users" do
      users = users_fixture()
      assert {:ok, %Users{}} = Crud.delete_users(users)
      assert_raise Ecto.NoResultsError, fn -> Crud.get_users!(users.id) end
    end

    test "change_users/1 returns a users changeset" do
      users = users_fixture()
      assert %Ecto.Changeset{} = Crud.change_users(users)
    end
  end

  describe "clocks" do
    alias Gothamapi.Crud.Clocks

    import Gothamapi.CrudFixtures

    @invalid_attrs %{status: nil, time: nil}

    test "list_clocks/0 returns all clocks" do
      clocks = clocks_fixture()
      assert Crud.list_clocks() == [clocks]
    end

    test "get_clocks!/1 returns the clocks with given id" do
      clocks = clocks_fixture()
      assert Crud.get_clocks!(clocks.id) == clocks
    end

    test "create_clocks/1 with valid data creates a clocks" do
      valid_attrs = %{status: true, time: ~N[2021-10-26 16:19:00]}

      assert {:ok, %Clocks{} = clocks} = Crud.create_clocks(valid_attrs)
      assert clocks.status == true
      assert clocks.time == ~N[2021-10-26 16:19:00]
    end

    test "create_clocks/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Crud.create_clocks(@invalid_attrs)
    end

    test "update_clocks/2 with valid data updates the clocks" do
      clocks = clocks_fixture()
      update_attrs = %{status: false, time: ~N[2021-10-27 16:19:00]}

      assert {:ok, %Clocks{} = clocks} = Crud.update_clocks(clocks, update_attrs)
      assert clocks.status == false
      assert clocks.time == ~N[2021-10-27 16:19:00]
    end

    test "update_clocks/2 with invalid data returns error changeset" do
      clocks = clocks_fixture()
      assert {:error, %Ecto.Changeset{}} = Crud.update_clocks(clocks, @invalid_attrs)
      assert clocks == Crud.get_clocks!(clocks.id)
    end

    test "delete_clocks/1 deletes the clocks" do
      clocks = clocks_fixture()
      assert {:ok, %Clocks{}} = Crud.delete_clocks(clocks)
      assert_raise Ecto.NoResultsError, fn -> Crud.get_clocks!(clocks.id) end
    end

    test "change_clocks/1 returns a clocks changeset" do
      clocks = clocks_fixture()
      assert %Ecto.Changeset{} = Crud.change_clocks(clocks)
    end
  end

  describe "worktimes" do
    alias Gothamapi.Crud.Workingtimes

    import Gothamapi.CrudFixtures

    @invalid_attrs %{end: nil, start: nil}

    test "list_worktimes/0 returns all worktimes" do
      workingtimes = workingtimes_fixture()
      assert Crud.list_worktimes() == [workingtimes]
    end

    test "get_workingtimes!/1 returns the workingtimes with given id" do
      workingtimes = workingtimes_fixture()
      assert Crud.get_workingtimes!(workingtimes.id) == workingtimes
    end

    test "create_workingtimes/1 with valid data creates a workingtimes" do
      valid_attrs = %{end: ~N[2021-10-26 16:19:00], start: ~N[2021-10-26 16:19:00]}

      assert {:ok, %Workingtimes{} = workingtimes} = Crud.create_workingtimes(valid_attrs)
      assert workingtimes.end == ~N[2021-10-26 16:19:00]
      assert workingtimes.start == ~N[2021-10-26 16:19:00]
    end

    test "create_workingtimes/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Crud.create_workingtimes(@invalid_attrs)
    end

    test "update_workingtimes/2 with valid data updates the workingtimes" do
      workingtimes = workingtimes_fixture()
      update_attrs = %{end: ~N[2021-10-27 16:19:00], start: ~N[2021-10-27 16:19:00]}

      assert {:ok, %Workingtimes{} = workingtimes} = Crud.update_workingtimes(workingtimes, update_attrs)
      assert workingtimes.end == ~N[2021-10-27 16:19:00]
      assert workingtimes.start == ~N[2021-10-27 16:19:00]
    end

    test "update_workingtimes/2 with invalid data returns error changeset" do
      workingtimes = workingtimes_fixture()
      assert {:error, %Ecto.Changeset{}} = Crud.update_workingtimes(workingtimes, @invalid_attrs)
      assert workingtimes == Crud.get_workingtimes!(workingtimes.id)
    end

    test "delete_workingtimes/1 deletes the workingtimes" do
      workingtimes = workingtimes_fixture()
      assert {:ok, %Workingtimes{}} = Crud.delete_workingtimes(workingtimes)
      assert_raise Ecto.NoResultsError, fn -> Crud.get_workingtimes!(workingtimes.id) end
    end

    test "change_workingtimes/1 returns a workingtimes changeset" do
      workingtimes = workingtimes_fixture()
      assert %Ecto.Changeset{} = Crud.change_workingtimes(workingtimes)
    end
  end
end
