defmodule PercentageCalc.Entries.Entry do
  use Ecto.Schema
  import Ecto.Changeset

  schema "entries" do
    field :email, :string
    field :name, :string
    field :percentage, :float

    timestamps()
  end

  @doc false
  def changeset(entry, attrs) do
    entry
    |> cast(attrs, [:name, :email, :percentage])
    |> validate_required([:name, :email, :percentage])
  end
end
