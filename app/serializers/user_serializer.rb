class UserSerializer < ApplicationSerializer
  attributes *[
    :name,
    :avatar_url,

    :online_at,
    :fighting_now_at,
    :matching_at,
    :lifetime_key,
    :platoon_key,
    :self_preset_key,
    :oppo_preset_key,
  ]

  belongs_to :current_battle_room
end
