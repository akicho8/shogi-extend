require File.expand_path('../../../../config/environment', __FILE__) if $0 == __FILE__

module Fanta
  class OnlineUserSerializer < SimpleUserSerializer
    attributes *[
      :fighting_at,
      :matching_at,
    ]

    has_many :active_battles, serializer: ActiveBattleEachSerializer

    # belongs_to :current_battle
    # class BattleSerializer < ApplicationSerializer
    #   attributes :name, :show_path
    # end
  end

  if $0 == __FILE__
    tp ams_sr(User.last, serializer: OnlineUserSerializer, include: [:active_battles])
  end
end
# >> I, [2018-07-02T18:37:11.699622 #19414]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (1873.38ms)
# >> |----------------+------------------------------------------------------------------------------------------------------------------------|
# >> |             id | 46                                                                                                                     |
# >> |           name | CPU4号                                                                                                                 |
# >> |      show_path | /online/users/46                                                                                                       |
# >> |     avatar_url | /assets/robot/0100_robot-66c73ea6ee9d1d87bad3f3b22739b74cbe9bdba17b06e9f65a8f7f63b6fb2467.png                          |
# >> |       race_key | robot                                                                                                                  |
# >> |    fighting_at | 2018-07-02 18:37:02 +0900                                                                                              |
# >> |    matching_at |                                                                                                                        |
# >> | active_battles | [{:id=>67, :name=>"#67", :show_path=>"/online/battles/67"}, {:id=>68, :name=>"#68", :show_path=>"/online/battles/68"}] |
# >> |----------------+------------------------------------------------------------------------------------------------------------------------|
