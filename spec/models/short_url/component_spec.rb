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

module ShortUrl
  RSpec.describe Component do
    it "基本形" do
      record = Component.from("/")
      record = Component.fetch(key: record.key)
      assert { record.compact_url == "http://localhost:3000/u/#{record.key}" }
    end

    it "リダイレクトしたと仮定すると履歴ができる" do
      record = Component.from("/")
      assert { record.access_logs.count == 0 }
      record.access_logs.create!
      assert { record.access_logs.count == 1 }
    end

    it "単にURLから短縮URLに変換する" do
      record = Component.from("/")
      assert { record.compact_url == "http://localhost:3000/u/UaswCQacfXi" }
    end
  end
end
