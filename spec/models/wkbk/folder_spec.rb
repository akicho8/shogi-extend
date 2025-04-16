# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Folder (wkbk_folders as Wkbk::Folder)
#
# |----------------+----------------+-------------+---------------------+------+-------|
# | name           | desc           | type        | opts                | refs | index |
# |----------------+----------------+-------------+---------------------+------+-------|
# | id             | ID             | integer(8)  | NOT NULL PK         |      |       |
# | key            | キー           | string(255) | NOT NULL            |      | A!    |
# | position       | 順序           | integer(4)  | NOT NULL            |      | B     |
# | books_count    | Books count    | integer(4)  | DEFAULT(0) NOT NULL |      |       |
# | articles_count | Articles count | integer(4)  | DEFAULT(0) NOT NULL |      |       |
# | created_at     | 作成日時       | datetime    | NOT NULL            |      |       |
# | updated_at     | 更新日時       | datetime    | NOT NULL            |      |       |
# |----------------+----------------+-------------+---------------------+------+-------|

require "rails_helper"

RSpec.describe Wkbk::Folder, type: :model do
  include WkbkSupportMethods

  it "relation" do
    assert { Wkbk::Book.first.folder.kind_of?(Wkbk::Folder) }
  end

  it "relation" do
    assert { Wkbk::Folder.first.books.present? }
  end
end
