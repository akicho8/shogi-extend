require File.expand_path('../../../../config/environment', __FILE__) if $0 == __FILE__

module Fanta
  class ChatUserSerializer < SimpleUserSerializer
    attributes *[
      :fighting_at,
      :matching_at,
    ]

    belongs_to :current_battle
    class BattleSerializer < ApplicationSerializer
      attributes :name, :show_path
    end
  end

  if $0 == __FILE__
    tp ams_sr(User.first, serializer: ChatUserSerializer)
  end
end
# >> I, [2018-07-02T12:14:26.623382 #1373]  INFO -- : Rendered Fanta::ChatUserSerializer with ActiveModelSerializers::Adapter::Attributes (3284.55ms)
# >> |----------------+--------------------------------------------------------------------------------------------------------------|
# >> |             id | 1                                                                                                            |
# >> |           name | SYSOP                                                                                                        |
# >> |      show_path | /online/users/1                                                                                              |
# >> |     avatar_url | /assets/human/0013_fallback_avatar_icon-7ccc24e76f53875ea71137f6079ae8ad0657b15e80aeed6852501da430e757df.png |
# >> |       race_key | human                                                                                                        |
# >> |    fighting_at |                                                                                                              |
# >> |    matching_at |                                                                                                              |
# >> | current_battle |                                                                                                              |
# >> |----------------+--------------------------------------------------------------------------------------------------------------|
