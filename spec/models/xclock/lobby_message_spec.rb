# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Lobby message (xclock_lobby_messages as Xclock::LobbyMessage)
#
# |------------+----------+-------------+-------------+--------------+-------|
# | name       | desc     | type        | opts        | refs         | index |
# |------------+----------+-------------+-------------+--------------+-------|
# | id         | ID       | integer(8)  | NOT NULL PK |              |       |
# | user_id    | User     | integer(8)  | NOT NULL    | => ::User#id | A     |
# | body       | 内容     | string(512) | NOT NULL    |              |       |
# | created_at | 作成日時 | datetime    | NOT NULL    |              |       |
# | updated_at | 更新日時 | datetime    | NOT NULL    |              |       |
# |------------+----------+-------------+-------------+--------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

require 'rails_helper'

module Xclock
  RSpec.describe LobbyMessage, type: :model do
    include XclockSupportMethods

    it "発言" do
      # /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/rspec-rails-4.0.0/lib/rspec/rails/matchers/action_cable.rb
      expect {
        user1.xclock_lobby_messages.create!(body: "message")
      }.to have_broadcasted_to("xclock/lobby_channel")
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> .
# >> 
# >> Finished in 0.65768 seconds (files took 2.13 seconds to load)
# >> 1 example, 0 failures
# >> 
