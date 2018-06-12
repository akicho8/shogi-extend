class CurrentUserSerializer < SimpleUserSerializer
  attributes :lifetime_key, :platoon_key, :self_preset_key, :oppo_preset_key # ルール設定情報
end
