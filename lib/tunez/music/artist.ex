defmodule Tunez.Music.Artist do
  use Ash.Resource, otp_app: :tunez, domain: Tunez.Music, data_layer: AshPostgres.DataLayer

  relationships do
    has_many :albums, Tunez.Music.Album do
      sort year_released: :desc
    end
  end


  postgres do
    table "artists"
    repo Tunez.Repo
  end

  actions do
    defaults [:create, :read, :destroy]

    update :update do
      accept [:name, :biography]
      require_atomic? false
        change Tunez.Music.Changes.UpdatePreviousNames, where: [changing(:name)]
    end

    default_accept [:name, :biography]
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string do
      allow_nil? false
    end

    attribute :biography, :string

    attribute :previous_names, {:array, :string} do
      default []
    end

    create_timestamp :inserted_at
    update_timestamp :updated_at
  end
end
