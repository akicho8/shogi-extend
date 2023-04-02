module ShareBoard
  class Dashboard

    def initialize(params)
      @params = params
    end

    # GET http://localhost:3000/api/share_board/dashboard?room_code=dev_room
    def call

      room = Room.fetch(@params[:room_code])
      room.as_json({
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
            battles: {
              only: [
                :sfen,
                :position,
                :created_at,
              ],
              include: {
                win_location: {
                  only: [
                    :key,
                  ],
                },
                black: MEMBERSHIP_STRUCT_TYPE1,
                white: MEMBERSHIP_STRUCT_TYPE1,
                # memberships: MEMBERSHIP_STRUCT_TYPE1,
              },
            },
          },
        })
    end

    private

    MEMBERSHIP_STRUCT_TYPE1 = {
      # only: [
      #   :position,
      # ],
      include: {
        user: {
          only: [
            :name,
          ],
        },
        # judge: {
        #   only: [
        #     :key,
        #   ],
        # },
        # location: {
        #   only: [
        #     :key,
        #   ],
        # },
      },
    }

  end
end
