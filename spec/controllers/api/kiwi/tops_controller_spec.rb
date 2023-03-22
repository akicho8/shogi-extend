# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Banana (kiwi_bananas as Kiwi::Banana)
#
# |----------------+--------------------+--------------+---------------------+--------------+-------|
# | name           | desc               | type         | opts                | refs         | index |
# |----------------+--------------------+--------------+---------------------+--------------+-------|
# | id             | ID                 | integer(8)   | NOT NULL PK         |              |       |
# | key            | ユニークなハッシュ | string(255)  | NOT NULL            |              | A     |
# | user_key        | User               | integer(8)   | NOT NULL            | => ::User#id | B     |
# | folder_key      | Folder             | integer(8)   | NOT NULL            |              | C     |
# | sequence_key    | Sequence           | integer(8)   | NOT NULL            |              | D     |
# | title          | タイトル           | string(255)  |                     |              |       |
# | description    | 説明               | string(1024) |                     |              |       |
# | lemons_count | Articles count     | integer(4)   | DEFAULT(0) NOT NULL |              |       |
# | created_at     | 作成日時           | datetime     | NOT NULL            |              |       |
# | updated_at     | 更新日時           | datetime     | NOT NULL            |              |       |
# |----------------+--------------------+--------------+---------------------+--------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

require "rails_helper"

RSpec.describe Api::Kiwi::TopsController, type: :controller, kiwi: true do
  include KiwiSupport

  it "index" do
    user_login(User.sysop)
    get :index
    is_asserted_by { response.status == 200 }
  end

  it "sitemap" do
    get :sitemap
    is_asserted_by { response.status == 200 }
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> ..
# >>
# >> Finished in 4.45 seconds (files took 2.89 seconds to load)
# >> 2 examples, 0 failures
# >>
