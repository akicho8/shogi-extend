module ShareBoard
  class Dashboard
    def initialize(params)
      @params = params
    end

    # GET http://localhost:3000/api/share_board/dashboard?room_key=dev_room
    # GET http://localhost:3000/api/share_board/dashboard?room_key=xxx
    # GET https://www.shogi-extend.com/api/share_board/dashboard?room_key=5%E6%9C%88%E9%8A%80%E6%B2%B3%E6%88%A6
    def call
      room = Room.find_or_initialize_by(key: @params[:room_key])
      room.as_json({
          only: [
            :key,
          ],
          include: {
            roomships: {
              only: [
                :win_count,
                :lose_count,
                :battles_count,
                :win_rate,
                :score,
                :rank,
              ],
              include: {
                user: {
                  only: [
                    :name,
                  ],
                },
              },
            },
          },
          methods: [:latest_battles_max, :latest_battles],
        })
    end
  end
end
