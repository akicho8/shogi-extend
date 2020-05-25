module Actb
  class RoomMembership < ApplicationRecord
    belongs_to :user, class_name: "Colosseum::User" # , foreign_key: "colosseum_user_id"
    belongs_to :room

    acts_as_list top_of_list: 0, scope: :room
  end
end
