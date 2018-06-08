require File.expand_path('../../../config/environment', __FILE__) if $0 == __FILE__

class BattleRoomSerializer < ApplicationSerializer
  attributes *[
    :black_preset_key,
    :white_preset_key,
    :lifetime_key,
    :platoon_key,
    :name,
    :kifu_body_sfen,
    :clock_counts,
    :turn_max,
    :battle_request_at,
    :auto_matched_at,
    :begin_at,
    :end_at,
    :last_action_key,
    :win_location_key,
    :current_users_count,
    :watch_memberships_count,
    :countdown_mode_hash,

    :show_path,
    :handicap,

    :human_kifu_text,           # これは重い

    :chat_window_size,
  ]

  has_many :room_chat_messages

  # :room_chat_messages => ams_sr(current_record.room_chat_messages.latest_list),

  # attribute :can_edit
  #
  # def can_edit
  #   view_context.current_user.id
  # end

  has_many :watch_users
  class UserSerializer < ApplicationSerializer
    attributes :name, :avatar_url
  end

  has_many :memberships

  # class MembershipSerializer < ApplicationSerializer
  #   attributes *[
  #     :preset_key,
  #     :location_key,
  #     :standby_at,
  #     :fighting_now_at,
  #     :time_up_trigger_at,
  #   ]
  #
  #   belongs_to :user
  #   class UserSerializer < ApplicationSerializer
  #     attributes :name, :avatar_url
  #   end
  # end
end

if $0 == __FILE__
  pp ActiveModelSerializers::SerializableResource.new(BattleRoom.first, include: {memberships: :user}).as_json
end
# >> {:id=>1,
# >>  :black_preset_key=>"平手",
# >>  :white_preset_key=>"平手",
# >>  :lifetime_key=>"lifetime_m5",
# >>  :name=>"#1",
# >>  :kifu_body_sfen=>
# >>   "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1",
# >>  :clock_counts=>{:black=>[], :white=>[]},
# >>  :turn_max=>0,
# >>  :battle_request_at=>Sat, 02 Jun 2018 22:28:24 JST +09:00,
# >>  :auto_matched_at=>nil,
# >>  :begin_at=>Sat, 02 Jun 2018 22:28:26 JST +09:00,
# >>  :end_at=>nil,
# >>  :last_action_key=>nil,
# >>  :win_location_key=>nil,
# >>  :current_users_count=>0,
# >>  :watch_memberships_count=>0,
# >>  :countdown_mode_hash=>{:black=>false, :white=>false},
# >>  :show_path=>"/online/battles/1",
# >>  :handicap=>false,
# >>  :human_kifu_text=>
# >>   "開始日時：2018/06/02 22:28:26\n" +
# >>   "場所：http://localhost:3000/online/battles/1\n" +
# >>   "先手：？\n" +
# >>   "後手：？\n" +
# >>   "手合割：平手\n" +
# >>   "\n" +
# >>   "まで0手で後手の勝ち\n",
# >>  :chat_window_size=>10,
# >>  :memberships=>[]}
