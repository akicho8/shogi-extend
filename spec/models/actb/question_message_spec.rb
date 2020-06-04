# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Question message (actb_question_messages as Actb::QuestionMessage)
#
# |-------------+----------+-------------+-------------+-----------------------+-------|
# | name        | desc     | type        | opts        | refs                  | index |
# |-------------+----------+-------------+-------------+-----------------------+-------|
# | id          | ID       | integer(8)  | NOT NULL PK |                       |       |
# | user_id     | User     | integer(8)  | NOT NULL    | => Colosseum::User#id | A     |
# | question_id | Question | integer(8)  | NOT NULL    |                       | B     |
# | body        | 内容     | string(140) | NOT NULL    |                       |       |
# | created_at  | 作成日時 | datetime    | NOT NULL    |                       |       |
# | updated_at  | 更新日時 | datetime    | NOT NULL    |                       |       |
# |-------------+----------+-------------+-------------+-----------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# Colosseum::User.has_many :actb_room_messages
#--------------------------------------------------------------------------------

require 'rails_helper'

module Actb
  RSpec.describe QuestionMessage, type: :model do
    include ActbSupportMethods

    it "問題に対してコメント" do
      # /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/rspec-rails-4.0.0/lib/rspec/rails/matchers/action_cable.rb
      expect {
        question1.messages.create!(user: user1, body: "message")
      }.to have_broadcasted_to("actb/question_channel/#{question1.id}")
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> .
# >> 
# >> Finished in 0.65982 seconds (files took 2.26 seconds to load)
# >> 1 example, 0 failures
# >> 
