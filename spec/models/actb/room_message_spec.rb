# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Room message (actb_room_messages as Actb::RoomMessage)
#
# |------------+----------+-------------+-------------+-----------------------+-------|
# | name       | desc     | type        | opts        | refs                  | index |
# |------------+----------+-------------+-------------+-----------------------+-------|
# | id         | ID       | integer(8)  | NOT NULL PK |                       |       |
# | user_id    | User     | integer(8)  | NOT NULL    | => Colosseum::User#id | A     |
# | room_id    | Room     | integer(8)  | NOT NULL    |                       | B     |
# | body       | 内容     | string(140) | NOT NULL    |                       |       |
# | created_at | 作成日時 | datetime    | NOT NULL    |                       |       |
# | updated_at | 更新日時 | datetime    | NOT NULL    |                       |       |
# |------------+----------+-------------+-------------+-----------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# Colosseum::User.has_one :actb_master_xrecord
#--------------------------------------------------------------------------------

require 'rails_helper'

module Actb
  RSpec.describe RoomMessage, type: :model do
    before do
      Actb.setup
    end

    let(:room) { Actb::Room.create! }

    # /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/rspec-rails-4.0.0/lib/rspec/rails/matchers/action_cable.rb
    it do
      expect {
        room.messages.create!(user: Colosseum::User.sysop, body: "(body)")
      }.to have_broadcasted_to("actb/room_channel/#{room.id}")
    end
  end
end
