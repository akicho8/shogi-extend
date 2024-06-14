# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Component (short_url_components as ShortUrl::Component)
#
# |-------------------+-------------------+--------------+---------------------+------+-------|
# | name              | desc              | type         | opts                | refs | index |
# |-------------------+-------------------+--------------+---------------------+------+-------|
# | id                | ID                | integer(8)   | NOT NULL PK         |      |       |
# | key               | キー              | string(255)  | NOT NULL            |      | A!    |
# | original_url      | Original url      | string(2048) | NOT NULL            |      |       |
# | access_logs_count | Access logs count | integer(4)   | DEFAULT(0) NOT NULL |      |       |
# | created_at        | 作成日時          | datetime     | NOT NULL            |      |       |
# | updated_at        | 更新日時          | datetime     | NOT NULL            |      |       |
# |-------------------+-------------------+--------------+---------------------+------+-------|

require "rails_helper"

RSpec.describe Api::ShortUrl::ComponentsController, type: :controller do
  it "works" do
    record = ShortUrl.from("/")
    post :create, params: { original_url: "/", format: "json" }
    assert { response.status == 200 }
    assert { response.body == record.compact_url }
  end
end
