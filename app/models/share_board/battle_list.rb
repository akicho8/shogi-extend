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
      hv = {}
      hv[:key]      = room.key
      hv[:total]    = room.battles_count
      hv[:page]     = params[:page].to_i
      hv[:per]      = params[:per].to_i
      hv[:battles]  = room.latest_battles(page: params[:page].to_i, per: params[:per].to_i)
      hv
    end

    private

    attr_reader :params
  end
end
