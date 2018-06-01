class ChatUserSerializer < ApplicationSerializer
  attributes *[
    :id,
    :name,
    :avatar_url,

    :current_chat_room_id,
    :online_at,
    :fighting_now_at,
    :matching_at,
    :lifetime_key,
    :ps_preset_key,
    :po_preset_key,
  ]
end
