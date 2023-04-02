module ShareBoard
  class Membership < ApplicationRecord
    custom_belongs_to :location, ar_model: Location, st_model: LocationInfo, default: nil
    custom_belongs_to :judge,    ar_model: Judge,    st_model: JudgeInfo,    default: nil

    belongs_to :battle                                 # 対局
    belongs_to :user, touch: true, counter_cache: true # 対局者
    has_one :room, through: :battle                    # 部屋

    scope :position_order, -> { order(:position) }

    acts_as_list top_of_list: 0, scope: :battle

    after_create :zadd_call

    def user_name=(name)
      self.user = User[name]
    end

    def zadd_call
      roomship = Roomship.find_or_initialize_by(room: room, user: user)
      roomship.win_count = room.ox_count_by_user(user, :win)
      roomship.lose_count = room.ox_count_by_user(user, :lose)
      roomship.save!
    end
  end
end
