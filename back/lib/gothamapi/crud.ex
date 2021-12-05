defmodule Gothamapi.Crud do
  @moduledoc """
  The Crud context.
  """

  import Ecto.Query, warn: false
  alias Gothamapi.Repo

  alias Gothamapi.Crud.Users

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%Users{}, ...]

  """
  #def list_users do
  # Repo.all(Users)
  #end

  def list_users do
    query = from u in Users, select: u, order_by: u.id
    Repo.all(query)
  end

  def get_user_by_email(email) do
    query = from u in Users, where: u.email == ^email
    case Repo.one(query) do
      nil -> {:error, :not_found}
      users -> {:ok, users}
    end
  end

  #case Repo.all(query) do
  # nil -> {:error, :not_found}
  #users -> {:ok, users}
  #end

  def get_user_by_username(username) do
    query = from u in Users, where: u.username == ^username, select: u
    case Repo.all(query) do
      [] -> {:error, :not_found}
      users -> {:ok, users}
    end
  end

  def authenticate_user(email, password) do
    with {:ok, users} <- get_user_by_email(email) do
      case validate_password(password, users.password) do
        false -> {:error, :unauthorized}
        true -> {:ok, users}
      end
    end
  end

  defp validate_password(password, encrypted_password) do
    Bcrypt.verify_pass(password, encrypted_password)
  end

  @doc """
  Gets a single users.

  Raises `Ecto.NoResultsError` if the Users does not exist.

  ## Examples

      iex> get_users!(123)
      %Users{}

      iex> get_users!(456)
      ** (Ecto.NoResultsError)

  """
  def get_users!(id), do: Repo.get!(Users, id)

  @doc """
  Creates a users.

  ## Examples

      iex> create_users(%{field: value})
      {:ok, %Users{}}

      iex> create_users(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_users(attrs \\ %{}) do
    %Users{}
    |> Users.registration_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a users.

  ## Examples

      iex> update_users(users, %{field: new_value})
      {:ok, %Users{}}

      iex> update_users(users, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_users(%Users{} = users, attrs) do
    users
    |> Users.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a users.

  ## Examples

      iex> delete_users(users)
      {:ok, %Users{}}

      iex> delete_users(users)
      {:error, %Ecto.Changeset{}}

  """
  def delete_users(%Users{} = users) do
    Repo.delete(users)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking users changes.

  ## Examples

      iex> change_users(users)
      %Ecto.Changeset{data: %Users{}}

  """
  def change_users(%Users{} = users, attrs \\ %{}) do
    Users.changeset(users, attrs)
  end

  alias Gothamapi.Crud.Clocks

  @doc """
  Returns the list of clocks.

  ## Examples

      iex> list_clocks()
      [%Clocks{}, ...]

  """
  def list_clocks do
    #query = from c in Clocks, join: u in Users, on: c.user_id == u.id
    #query = from [c, u] in query, select: [c, u]
    Repo.all(Clocks)
  end

  def list_clocksByUserId(id) do
    query = from u in Clocks, where: u.user_id == ^id, select: u
    Repo.all(query)
  end

  def list_clocksByUsername(username) do
    query = from c in Clocks, join: u in Users, on: c.user_id == u.id
    query = from [c, u] in query, where: u.username == ^username
    Repo.all(query)
  end

  @doc """
  Gets a single clocks.

  Raises `Ecto.NoResultsError` if the Clocks does not exist.

  ## Examples

      iex> get_clocks!(123)
      %Clocks{}

      iex> get_clocks!(456)
      ** (Ecto.NoResultsError)

  """
  def get_clocks!(id), do: Repo.get!(Clocks, id)

  @doc """
  Creates a clocks.

  ## Examples

      iex> create_clocks(%{field: value})
      {:ok, %Clocks{}}

      iex> create_clocks(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_clocks(attrs \\ %{}) do
    %Clocks{}
    |> Clocks.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a clocks.

  ## Examples

      iex> update_clocks(clocks, %{field: new_value})
      {:ok, %Clocks{}}

      iex> update_clocks(clocks, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_clocks(%Clocks{} = clocks, attrs) do
    clocks
    |> Clocks.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a clocks.

  ## Examples

      iex> delete_clocks(clocks)
      {:ok, %Clocks{}}

      iex> delete_clocks(clocks)
      {:error, %Ecto.Changeset{}}

  """
  def delete_clocks(%Clocks{} = clocks) do
    Repo.delete(clocks)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking clocks changes.

  ## Examples

      iex> change_clocks(clocks)
      %Ecto.Changeset{data: %Clocks{}}

  """
  def change_clocks(%Clocks{} = clocks, attrs \\ %{}) do
    Clocks.changeset(clocks, attrs)
  end

  alias Gothamapi.Crud.Workingtimes

  @doc """
  Returns the list of worktimes.

  ## Examples

      iex> list_worktimes()
      [%Workingtimes{}, ...]

  """
  def list_worktimes do
    Repo.all(Workingtimes)
  end

  def list_worktimesByUser(user_id, start, endTime) do
    query = from u in Workingtimes,
                 where: u.user_id == ^user_id and u.start == ^start and u.end == ^endTime, select: u
    Repo.all(query)
  end

  def list_worktimesByUserID(user_id) do
    query = from u in Workingtimes, where: u.user_id == ^user_id, select: u
    Repo.all(query)
  end

  def list_worktimesByUsername(username) do
    query = from w in Workingtimes, join: u in Users, on: w.user_id == u.id
    query = from [w, u] in query, where: u.username == ^username
    Repo.all(query)
  end

  @doc """
  Gets a single workingtimes.

  Raises `Ecto.NoResultsError` if the Workingtimes does not exist.

  ## Examples

      iex> get_workingtimes!(123)
      %Workingtimes{}

      iex> get_workingtimes!(456)
      ** (Ecto.NoResultsError)

  """
  def get_workingtimes!(id), do: Repo.get!(Workingtimes, id)

  @doc """
  Creates a workingtimes.

  ## Examples

      iex> create_workingtimes(%{field: value})
      {:ok, %Workingtimes{}}

      iex> create_workingtimes(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_workingtimes(attrs \\ %{}) do
    %Workingtimes{}
    |> Workingtimes.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a workingtimes.

  ## Examples

      iex> update_workingtimes(workingtimes, %{field: new_value})
      {:ok, %Workingtimes{}}

      iex> update_workingtimes(workingtimes, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_workingtimes(%Workingtimes{} = workingtimes, attrs) do
    workingtimes
    |> Workingtimes.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a workingtimes.

  ## Examples

      iex> delete_workingtimes(workingtimes)
      {:ok, %Workingtimes{}}

      iex> delete_workingtimes(workingtimes)
      {:error, %Ecto.Changeset{}}

  """
  def delete_workingtimes(%Workingtimes{} = workingtimes) do
    Repo.delete(workingtimes)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking workingtimes changes.

  ## Examples

      iex> change_workingtimes(workingtimes)
      %Ecto.Changeset{data: %Workingtimes{}}

  """
  def change_workingtimes(%Workingtimes{} = workingtimes, attrs \\ %{}) do
    Workingtimes.changeset(workingtimes, attrs)
  end
end
