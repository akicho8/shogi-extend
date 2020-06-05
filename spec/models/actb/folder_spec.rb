# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Folder (actb_folders as Actb::Folder)
#
# |------------+------------+-------------+-------------+--------------------+-------|
# | name       | desc       | type        | opts        | refs               | index |
# |------------+------------+-------------+-------------+--------------------+-------|
# | id         | ID         | integer(8)  | NOT NULL PK |                    |       |
# | user_id    | User       | integer(8)  | NOT NULL    | => User#id         | A! B  |
# | type       | 所属モデル | string(255) | NOT NULL    | SpecificModel(STI) | A!    |
# | created_at | 作成日時   | datetime    | NOT NULL    |                    |       |
# | updated_at | 更新日時   | datetime    | NOT NULL    |                    |       |
# |------------+------------+-------------+-------------+--------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_many :actb_room_messages
#--------------------------------------------------------------------------------

require 'rails_helper'

module Actb
  RSpec.describe Folder, type: :model do
    include ActbSupportMethods

    it do
      question1
      assert { user1.actb_active_box.questions.count >= 1 }
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> .
# >> 
# >> Finished in 0.73437 seconds (files took 2.19 seconds to load)
# >> 1 example, 0 failures
# >> 
