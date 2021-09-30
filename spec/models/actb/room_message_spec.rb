# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Room message (actb_room_messages as Actb::RoomMessage)
#
# |------------+----------+-------------+-------------+--------------+-------|
# | name       | desc     | type        | opts        | refs         | index |
# |------------+----------+-------------+-------------+--------------+-------|
# | id         | ID       | integer(8)  | NOT NULL PK |              |       |
# | user_id    | User     | integer(8)  | NOT NULL    | => ::User#id | A     |
# | room_id    | Room     | integer(8)  | NOT NULL    |              | B     |
# | body       | 内容     | string(512) | NOT NULL    |              |       |
# | created_at | 作成日時 | datetime    | NOT NULL    |              |       |
# | updated_at | 更新日時 | datetime    | NOT NULL    |              |       |
# |------------+----------+-------------+-------------+--------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

require "rails_helper"

module Actb
  RSpec.describe RoomMessage, type: :model do
    include ActbSupportMethods

    # /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/rspec-rails-4.0.0/lib/rspec/rails/matchers/action_cable.rb
    it do
      expect {
        room1.messages.create!(user: user1, body: "(body)")
      }.to have_broadcasted_to("actb/room_channel/#{room1.id}")
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> .
# >> 
# >> Finished in 0.67599 seconds (files took 2.18 seconds to load)
# >> 1 example, 0 failures
# >> 
