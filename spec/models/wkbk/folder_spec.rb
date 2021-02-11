# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Folder (wkbk_folders as Wkbk::Folder)
#
# |----------------+--------------------+-------------+---------------------+------+-------|
# | name           | desc               | type        | opts                | refs | index |
# |----------------+--------------------+-------------+---------------------+------+-------|
# | id             | ID                 | integer(8)  | NOT NULL PK         |      |       |
# | key            | ユニークなハッシュ | string(255) | NOT NULL            |      | A!    |
# | position       | 順序               | integer(4)  | NOT NULL            |      | B     |
# | books_count    | Books count        | integer(4)  | DEFAULT(0) NOT NULL |      |       |
# | articles_count | Articles count     | integer(4)  | DEFAULT(0) NOT NULL |      |       |
# | created_at     | 作成日時           | datetime    | NOT NULL            |      |       |
# | updated_at     | 更新日時           | datetime    | NOT NULL            |      |       |
# |----------------+--------------------+-------------+---------------------+------+-------|

require 'rails_helper'

module Wkbk
  RSpec.describe Folder, type: :model do
    include WkbkSupportMethods

    it "relation" do
      assert { Wkbk::Book.first.folder.kind_of?(Wkbk::Folder) }
    end

    it "relation" do
      assert { Wkbk::Folder.first.books.present? }
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> ...
# >>
# >> Finished in 0.72046 seconds (files took 2.15 seconds to load)
# >> 3 examples, 0 failures
# >>
