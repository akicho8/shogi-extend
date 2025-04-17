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

# == ShortUrl::Schema ShortUrl::Information ==
#
# ShortUrl::Component (short_url_components as ShortUrl::ShortUrl::Component)
#
# |-------------------+-------------------+--------------+---------------------+------+-------|
# | name              | desc              | type         | opts                | refs | index |
# |-------------------+-------------------+--------------+---------------------+------+-------|
# | id                | ID                | integer(8)   | NOT NULL PK         |      |       |
# | key               | キー              | string(255)  | NOT NULL            |      | A!    |
# | original_url      | ShortUrl::Original url      | string(2048) | NOT NULL            |      |       |
# | access_logs_count | ShortUrl::Access logs count | integer(4)   | DEFAULT(0) NOT NULL |      |       |
# | created_at        | 作成日時          | datetime     | NOT NULL            |      |       |
# | updated_at        | 更新日時          | datetime     | NOT NULL            |      |       |
# |-------------------+-------------------+--------------+---------------------+------+-------|

require "rails_helper"

RSpec.describe ShortUrl::Component do
  it "基本形" do
    record = ShortUrl::Component.from("/")
    record = ShortUrl::Component.fetch(key: record.key)
    assert { record.compact_url == "http://localhost:3000/u/#{record.key}" }
  end

  it "リダイレクトしたと仮定すると履歴ができる" do
    record = ShortUrl::Component.from("/")
    assert { record.access_logs.count == 0 }
    record.access_logs.create!
    assert { record.access_logs.count == 1 }
  end

  it "単にURLから短縮URLに変換する" do
    record = ShortUrl::Component.from("/")
    assert { record.compact_url == "http://localhost:3000/u/UaswCQacfXi" }
  end
end
