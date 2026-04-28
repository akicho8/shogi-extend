module ShareBoard
  class BattleList
    def initialize(params)
      @params = params
    end

    # GET http://localhost:3000/api/share_board/battle_list?room_key=dev_room&per=1&page=1
    # GET http://localhost:3000/api/share_board/battle_list?room_key=dev_room&per=1&page=2
    def call
      room = Room.all
      room = room.find_or_initialize_by(key: params[:room_key])
      {}.tap do |hv|
        hv[:key]     = room.key
        hv[:total]   = room.battles_count
        hv[:page]    = page
        hv[:per]     = per
        hv[:battles] = room.latest_battles(page: page, per: per)
      end
    end

    private

    attr_reader :params

    def page
      params.fetch(:page).to_i
    end

    def per
      params.fetch(:per).to_i
    end
  end
end
