# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Judge (judges as Judge)
#
# |------------+----------+-------------+-------------+------+-------|
# | name       | desc     | type        | opts        | refs | index |
# |------------+----------+-------------+-------------+------+-------|
# | id         | ID       | integer(8)  | NOT NULL PK |      |       |
# | key        | キー     | string(255) | NOT NULL    |      | A!    |
# | position   | 順序     | integer(4)  |             |      | B     |
# | created_at | 作成日時 | datetime    | NOT NULL    |      |       |
# | updated_at | 更新日時 | datetime    | NOT NULL    |      |       |
# |------------+----------+-------------+-------------+------+-------|

class CreateJudges < ActiveRecord::Migration[5.1]
  def up
    drop_table :judges rescue nil
    remove_column :swars_memberships, :judge_id rescue nil

    create_table :judges, force: true do |t|
      t.string :key,       null: false, index: { unique: true }
      t.integer :position, null: true,  index: true, comment: "順序"
      t.timestamps         null: false
    end

    Judge.reset_column_information
    Judge.setup

    change_table :swars_memberships do |t|
      t.belongs_to :judge, null: true, comment: "勝敗"
    end
  end
end
