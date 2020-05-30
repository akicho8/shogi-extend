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
# Colosseum::User.has_one :actb_master_xrecord
#--------------------------------------------------------------------------------

require 'rails_helper'

module Actb
  RSpec.describe QuestionMessage, type: :model do
    before do
      Actb.setup
    end

    let :question do
      Actb::Question.create!(user: sysop)
    end

    # https://github.com/palkan/action-cable-testing
    # /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/rspec-rails-4.0.0/lib/rspec/rails/matchers/action_cable.rb
    it do
      expect {
        question.messages.create!(user: sysop, body: "(body)")
      }.to have_broadcasted_to("actb/question_channel/#{question.id}") # .with(message: "<div>名無しの棋士1号: a</div>")
    end
  end
end
