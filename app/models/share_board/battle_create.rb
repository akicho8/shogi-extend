module ShareBoard
  class BattleCreate
    BUG_WORKAROUND = true

    attr_reader :battle
    attr_reader :error

    def initialize(params)
      @params = params
    end

    def call
      begin
        if @params[:fake_error]
          raise ActiveRecord::NotNullViolation.new("(fake_error)")
        end
        if BUG_WORKAROUND
          # 回避できるのかはわからないが TRANSACTION 内に入れなくてもいいものはなるべく別にしてみる
          memberships.each { |e| User.fetch(e[:user_name]) }
          @battle = room.battles.create!(battle_params)
          @battle.memberships.create!(memberships)
        else
          # 本来はこのようにすればよいはずだが production 環境では ActiveRecord::NotNullViolation (Mysql2::Error: Column 'user_id' cannot be null) がまれに起きる
          @battle = room.battles.create!(battle_params) do |e|
            e.memberships.build(memberships)
          end
        end

        func1

      rescue ActiveRecord::ActiveRecordError => error
        @error = error
        AppLog.critical(@error)
      end
      self
    end

    def as_json(...)
      hv = {}
      if error
        hv[:error] = { message: error.message }
      end
      hv
    end

    def success?
      !error
    end

    private

    def room
      @room ||= Room.fetch(room_key)
    end

    def room_key
      @params.fetch(:room_key)
    end

    def battle_params
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

    def func1
      room = battle.room
      battle.memberships.each do |membership|
        membership.user.name
        roomship = room.roomships.find_by!(user: membership.user)
        data = {
          "xbadge_user_name" => membership.user.name,
          "xbadge_count"     => roomship.win_count,
        }
        ShareBoard::Broadcaster.new(room.key).call("xbadge_dist_broadcasted", data)
      end
    end
  end
end
