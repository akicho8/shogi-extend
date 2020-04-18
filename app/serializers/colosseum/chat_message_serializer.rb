require File.expand_path('../../../../config/environment', __FILE__) if $0 == __FILE__

module Colosseum
  class ChatMessageSerializer < ApplicationSerializer
    attributes :message, :msg_options, :created_at
    belongs_to :user, serializer: SimpleUserSerializer
  end

  if $0 == __FILE__
    pp ams_sr(ChatMessage.first, serializer: ChatMessageSerializer)
  end
end
# >> {:id=>1,
# >>  :message=>"(message)",
# >>  :msg_options=>{},
# >>  :created_at=>Sat, 04 Aug 2018 15:08:37 JST +09:00,
# >>  :user=>
# >>   {:id=>1,
# >>    :name=>"運営",
# >>    :show_path=>"/colosseum/users/1",
# >>    :avatar_path=>
# >>     "/assets/human/0013_fallback_avatar_icon-7ccc24e76f53875ea71137f6079ae8ad0657b15e80aeed6852501da430e757df.png",
# >>    :race_key=>"human",
# >>    :win_count=>0,
# >>    :lose_count=>0,
# >>    :win_ratio=>0.0}}
