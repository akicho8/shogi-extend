require File.expand_path('../../../config/environment', __FILE__) if $0 == __FILE__

class ChatRoomEachSerializer < ApplicationSerializer
  attributes *[
    :black_preset_key,
    :white_preset_key,
    :lifetime_key,
    :platoon_key,
    :name,
    :kifu_body_sfen,
    :clock_counts,
    :turn_max,
    # :battle_request_at,
    # :auto_matched_at,
    :begin_at,
    :end_at,
    :last_action_key,
    :win_location_key,
    :current_users_count,
    :watch_memberships_count,
    :countdown_mode_hash,

    :show_path,
    :handicap,
  ]

  # attribute :can_edit
  #
  # def can_edit
  #   view_context.current_user.id
  # end

  # has_many :watch_users
  # class UserSerializer < ApplicationSerializer
  #   attributes :name, :avatar_url
  # end

  has_many :memberships
  class MembershipSerializer < ApplicationSerializer
    attributes *[
      # :preset_key,
      :location_key,
      # :standby_at,
      # :fighting_now_at,
      # :time_up_trigger_at,
    ]

    belongs_to :user
    class UserSerializer < ApplicationSerializer
      attributes :name, :avatar_url
    end
  end
end

if $0 == __FILE__
  pp ActiveModelSerializers::SerializableResource.new(ChatRoom.first, include: {memberships: :user}).as_json
end
# >> {:id=>1,
# >>  :room_owner_id=>1,
# >>  :black_preset_key=>"平手",
# >>  :white_preset_key=>"平手",
# >>  :lifetime_key=>"lifetime_m5",
# >>  :name=>"野良1号の対戦部屋 #1",
# >>  :kifu_body_sfen=>
# >>   "position startpos moves 7g7f 5c5d 2g2f 8c8d 1g1f 9c9d 2h2g 9a9b 1i1h",
# >>  :clock_counts=>{:black=>[3, 8, 6, 62, 3], :white=>[2, 43, 4, 20]},
# >>  :turn_max=>9,
# >>  :battle_request_at=>Sun, 27 May 2018 19:58:48 JST +09:00,
# >>  :auto_matched_at=>nil,
# >>  :begin_at=>Sun, 27 May 2018 19:58:51 JST +09:00,
# >>  :end_at=>Sun, 27 May 2018 20:01:37 JST +09:00,
# >>  :last_action_key=>"ILLEGAL_MOVE",
# >>  :win_location_key=>"black",
# >>  :current_users_count=>-2,
# >>  :watch_memberships_count=>0,
# >>  :show_path=>"/online/battles/1",
# >>  :handicap=>false,
# >>  :memberships=>
# >>   [{:id=>1,
# >>     :preset_key=>"平手",
# >>     :location_key=>"black",
# >>     :standby_at=>Sun, 27 May 2018 19:58:51 JST +09:00,
# >>     :fighting_now_at=>nil,
# >>     :time_up_trigger_at=>nil,
# >>     :user=>
# >>      {:id=>1,
# >>       :name=>"野良1号",
# >>       :avatar_url=>
# >>        "/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBDUT09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--bda60366d3f3573c24c096e0d889993b7ca06772/0270_kemono_friends.png"}},
# >>    {:id=>2,
# >>     :preset_key=>"平手",
# >>     :location_key=>"white",
# >>     :standby_at=>Sun, 27 May 2018 19:58:51 JST +09:00,
# >>     :fighting_now_at=>nil,
# >>     :time_up_trigger_at=>nil,
# >>     :user=>
# >>      {:id=>1,
# >>       :name=>"野良1号",
# >>       :avatar_url=>
# >>        "/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBDUT09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--bda60366d3f3573c24c096e0d889993b7ca06772/0270_kemono_friends.png"}}]}
