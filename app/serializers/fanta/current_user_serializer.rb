require File.expand_path('../../../../config/environment', __FILE__) if $0 == __FILE__

module Fanta
  class CurrentUserSerializer < SimpleUserSerializer
    attributes :lifetime_key, :platoon_key, :self_preset_key, :oppo_preset_key # ルール設定情報
    attributes :matching_at                                                    # マッチング開始日時
  end

  if $0 == __FILE__
    pp ams_sr(User.first, serializer: CurrentUserSerializer)
  end
end
