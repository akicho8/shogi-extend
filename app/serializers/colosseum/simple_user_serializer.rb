require File.expand_path('../../../../config/environment', __FILE__) if $0 == __FILE__

module Colosseum
  class SimpleUserSerializer < ApplicationSerializer
    attributes :name, :show_path, :avatar_url, :race_key
    attributes :win_count, :lose_count, :win_ratio
  end

  if $0 == __FILE__
    tp ams_sr(User.first, serializer: SimpleUserSerializer)
  end
end
# >> |------------+--------------------------------------------------------------------------------------------------------------|
# >> |         id | 14                                                                                                           |
# >> |       name | 名無しの棋士1号                                                                                              |
# >> |  show_path | /colosseum/users/14                                                                                          |
# >> | avatar_url | /assets/human/0012_fallback_avatar_icon-178e6778871d93f2ecc903e0fa22b878c89c0deaff8c2ea5fae7478d3e7210ff.png |
# >> |   race_key | human                                                                                                        |
# >> |  win_count | 1                                                                                                            |
# >> | lose_count | 1                                                                                                            |
# >> |   win_ratio | 0.5                                                                                                          |
# >> |------------+--------------------------------------------------------------------------------------------------------------|
