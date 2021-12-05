defmodule Gothamapi.Crud.Users do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :username, :string
    field :password, :string
    field :role, :boolean


    timestamps()
  end

  @doc false
  def changeset(users, attrs) do
    users
    |> cast(attrs, [:username, :email, :password, :role])
    |> validate_required([:username, :email, :password, :role])
    |> validate_format(:email, ~r/^[A-Za-z0-9.%+-]+@[A-Za-z0-9.-]+.[A-Za-z]{2,4}$/)
  end

  def registration_changeset(users, attrs) do
    users
    |> cast(attrs, [:username, :email, :password, :role])
    |> validate_required([:username, :email, :password, :role])
    |> validate_format(:email, ~r/^[A-Za-z0-9.%+-]+@[A-Za-z0-9.-]+.[A-Za-z]{2,4}$/)
    |> encrypt_and_put_password()
  end

  defp encrypt_and_put_password (users)do
    with password <- fetch_field!(users, :password) do
      encrypted_password = Bcrypt.Base.hash_password(password, Bcrypt.gen_salt(12, true))
      put_change(users, :password, encrypted_password)
    end
  end


end
