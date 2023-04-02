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
      Room.find_or_create_by!(key: room_code)
    end

    def room_code
      @params.fetch(:room_code)
    end

    def battle_params
      @params.fetch_values(*battle_columns)
      @params.slice(*battle_columns) # MEMO: fetch_values でハッシュを返すものがほしい
    end

    def battle_columns
      [:sfen, :turn, :title]
    end

    def memberships
      @params.fetch(:memberships)
    end
  end
end
