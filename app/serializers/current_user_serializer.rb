class CurrentUserSerializer < UserSerializer
  attributes *[
    # ルール設定情報
    :lifetime_key,
    :platoon_key,
    :self_preset_key,
    :oppo_preset_key,
  ]
end
