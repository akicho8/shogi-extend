# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Message (acns3_messages as Acns3::Message)
#
# |------------+----------+-------------+-------------+-----------------------+-------|
# | name       | desc     | type        | opts        | refs                  | index |
# |------------+----------+-------------+-------------+-----------------------+-------|
# | id         | ID       | integer(8)  | NOT NULL PK |                       |       |
# | user_id    | User     | integer(8)  |             | => Colosseum::User#id | A     |
# | room_id    | Room     | integer(8)  |             |                       | B     |
# | body       | 内容     | string(512) |             |                       |       |
# | created_at | 作成日時 | datetime    | NOT NULL    |                       |       |
# | updated_at | 更新日時 | datetime    | NOT NULL    |                       |       |
# |------------+----------+-------------+-------------+-----------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# Colosseum::User.has_many :acns2_memberships
#--------------------------------------------------------------------------------

require 'rails_helper'

module Acns3
  RSpec.describe Message, type: :model do
    let :user1 do
      Colosseum::User.create!
    end

    let :user2 do
      Colosseum::User.create!
    end

    let :room do
      Acns3::Room.create! do |e|
        e.memberships.build(user: user1, judge_key: "win")
        e.memberships.build(user: user2, judge_key: "lose")
      end
    end

    # https://github.com/palkan/action-cable-testing
    # /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/rspec-rails-4.0.0/lib/rspec/rails/matchers/action_cable.rb
    it do
      expect {
        room.messages.create!(user: user1, body: "a")
      }.to have_broadcasted_to("acns3/room_channel/#{room.id}").with(message: "<div>名無しの棋士1号: a</div>")
    end
  end
end
