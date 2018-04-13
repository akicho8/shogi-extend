# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 件名と本文のみテーブル (type022_articles as Type022Article)
#
# +------------+----------+----------+-------------+------+-------+
# | カラム名   | 意味     | タイプ   | 属性        | 参照 | INDEX |
# +------------+----------+----------+-------------+------+-------+
# | id         | ID       | integer  | NOT NULL PK |      |       |
# | subject    | 件名     | string   |             |      |       |
# | body       | 内容     | text     |             |      |       |
# | created_at | 作成日時 | datetime | NOT NULL    |      |       |
# | updated_at | 更新日時 | datetime | NOT NULL    |      |       |
# +------------+----------+----------+-------------+------+-------+

class CreateType022Articles < ActiveRecord::Migration[5.1]
  def up
    create_table :type022_articles, force: true do |t|
      t.text :body
      t.timestamps null: false
    end
  end
end
