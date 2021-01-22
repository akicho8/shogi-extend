# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Folder (wkbk_folders as Wkbk::Folder)
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
# User.has_one :profile
#--------------------------------------------------------------------------------

require 'rails_helper'

module Wkbk
  RSpec.describe Folder, type: :model do
    include WkbkSupportMethods

    it do
      article1
      assert { user1.wkbk_active_box.articles.count >= 1 }
    end

    it "folder_key" do
      assert { user1.wkbk_active_box.key == :active }
    end

    it "pure_class" do
      assert { article1.folder.pure_info.name == "公開" }
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> ...
# >> 
# >> Finished in 0.72046 seconds (files took 2.15 seconds to load)
# >> 3 examples, 0 failures
# >> 
