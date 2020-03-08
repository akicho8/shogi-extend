# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 各種棋譜ファイル内容 (converted_infos as ConvertedInfo)
#
# |------------------+------------------+----------------+-------------+----------------------------+-------|
# | name             | desc             | type           | opts        | refs                       | index |
# |------------------+------------------+----------------+-------------+----------------------------+-------|
# | id               | ID               | integer(8)     | NOT NULL PK |                            |       |
# | convertable_type | Convertable type | string(255)    | NOT NULL    | SpecificModel(polymorphic) | A     |
# | convertable_id   | Convertable      | integer(8)     | NOT NULL    | => (convertable_type)#id   | A     |
# | text_body        | 本体             | text(16777215) | NOT NULL    |                            |       |
# | text_format      | 種類             | string(255)    | NOT NULL    |                            | B     |
# | created_at       | 作成日時         | datetime       | NOT NULL    |                            |       |
# | updated_at       | 更新日時         | datetime       | NOT NULL    |                            |       |
# |------------------+------------------+----------------+-------------+----------------------------+-------|

class ConvertedInfo < ApplicationRecord
  belongs_to :convertable, polymorphic: true
  scope :text_format_eq, -> e { where(text_format: e) }
end
