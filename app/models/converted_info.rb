# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Converted infoテーブル (converted_infos as ConvertedInfo)
#
# |------------------+------------------+-------------+-------------+--------------------------+-------|
# | カラム名         | 意味             | タイプ      | 属性        | 参照                     | INDEX |
# |------------------+------------------+-------------+-------------+--------------------------+-------|
# | id               | ID               | integer(8)  | NOT NULL PK |                          |       |
# | convertable_type | Convertable type | string(255) |             | モデル名(polymorphic)    | A     |
# | convertable_id   | Convertable      | integer(8)  |             | => (convertable_type)#id | A     |
# | converted_body   | Converted body   | text(65535) | NOT NULL    |                          |       |
# | converted_format | Converted format | string(255) | NOT NULL    |                          | B     |
# | created_at       | 作成日時         | datetime    | NOT NULL    |                          |       |
# | updated_at       | 更新日時         | datetime    | NOT NULL    |                          |       |
# |------------------+------------------+-------------+-------------+--------------------------+-------|

class ConvertedInfo < ApplicationRecord
  belongs_to :convertable, polymorphic: true
  scope :format_eq, -> e { where(converted_format: e) }
end
