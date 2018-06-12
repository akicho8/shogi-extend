class UserSerializer < ApplicationSerializer
  attributes *[
    :name,
    :avatar_url,
    :show_path,

    :online_at,
    :fighting_now_at,
    :matching_at,
  ]

  belongs_to :current_battle_room
end
