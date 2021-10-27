# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 設定 (xsettings as Xsetting)
#
# |------------+----------+-------------+-------------+------+-------|
# | name       | desc     | type        | opts        | refs | index |
# |------------+----------+-------------+-------------+------+-------|
# | id         | ID       | integer(8)  | NOT NULL PK |      |       |
# | var_key    | 変数名   | string(255) | NOT NULL    |      | A!    |
# | var_value  | 変数値   | text(65535) |             |      |       |
# | created_at | 作成日時 | datetime    | NOT NULL    |      |       |
# | updated_at | 更新日時 | datetime    | NOT NULL    |      |       |
# |------------+----------+-------------+-------------+------+-------|

class CreateXsettings < ActiveRecord::Migration[6.0]
  def change
    create_table :xsettings, force: true do |t|
      t.string :var_key, null: false, index: { unique: true }
      t.text :var_value
      t.timestamps null: false
    end
  end
end
