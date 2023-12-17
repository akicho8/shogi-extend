module ShareBoard
  class BattleCreate
    attr_reader :battle

    def initialize(params)
      @params = params
    end

    def call
      @battle = room.battles.create!(battle_params) do |e|
        e.memberships.build(memberships)
      end

      self
    end

    def as_json(...)
      @battle.as_json(...)
    end

    private

    def room
      @room ||= Room.find_or_create_by!(key: room_key)
    end

    def room_key
      @params.fetch(:room_key)
    end

    def battle_params
      @params.fetch_values(*battle_columns)
      @params.slice(*battle_columns) # MEMO: fetch_values でハッシュを返すものがほしい
    end

    def battle_columns
      [
        :sfen,
        :turn,
        :title,
        :win_location_key,
      ]
    end

    def memberships
      @params.fetch(:memberships)
    end
  end
end
