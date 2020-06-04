# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Clip mark (actb_clip_marks as Actb::ClipMark)
#
# |-------------+----------+------------+-------------+-----------------------+-------|
# | name        | desc     | type       | opts        | refs                  | index |
# |-------------+----------+------------+-------------+-----------------------+-------|
# | id          | ID       | integer(8) | NOT NULL PK |                       |       |
# | user_id     | User     | integer(8) | NOT NULL    | => Colosseum::User#id | A! B  |
# | question_id | Question | integer(8) | NOT NULL    |                       | A! C  |
# | created_at  | 作成日時 | datetime   | NOT NULL    |                       |       |
# | updated_at  | 更新日時 | datetime   | NOT NULL    |                       |       |
# |-------------+----------+------------+-------------+-----------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# Colosseum::User.has_many :actb_room_messages
#--------------------------------------------------------------------------------

require 'rails_helper'

module Actb
  RSpec.describe ClipMark, type: :model do
    include ActbSupportMethods

    it "保存" do
      assert { user1.actb_clip_marks.create!(question: question1) }
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> .
# >> 
# >> Finished in 0.53863 seconds (files took 2.26 seconds to load)
# >> 1 example, 0 failures
# >> 
