# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 棋譜変換テーブル (kifu_convert_infos as KifuConvertInfo)
#
# |---------------+--------------------+----------+-------------+------+-------|
# | カラム名      | 意味               | タイプ   | 属性        | 参照 | INDEX |
# |---------------+--------------------+----------+-------------+------+-------|
# | id            | ID                 | integer  | NOT NULL PK |      |       |
# | unique_key    | ユニークなハッシュ | string   | NOT NULL    |      |       |
# | kifu_file     | 棋譜ファイル       | string   |             |      |       |
# | kifu_url      | 棋譜URL            | string   |             |      |       |
# | kifu_body     | 棋譜内容           | text     |             |      |       |
# | converted_ki2 | 変換後KI2          | text     |             |      |       |
# | converted_kif | 変換後KIF          | text     |             |      |       |
# | converted_csa | 変換後CSA          | text     |             |      |       |
# | turn_max      | 手数               | integer  |             |      |       |
# | kifu_header   | 棋譜ヘッダー       | text     |             |      |       |
# | created_at    | 作成日時           | datetime | NOT NULL    |      |       |
# | updated_at    | 更新日時           | datetime | NOT NULL    |      |       |
# |---------------+--------------------+----------+-------------+------+-------|

require "open-uri"

class KifuConvertInfo < ApplicationRecord
  mount_uploader :kifu_file, AttachmentUploader

  serialize :kifu_header

  before_validation do
    self.unique_key ||= SecureRandom.hex
    self.kifu_header ||= {}
    self.turn_max ||= 0

    if changes[:kifu_file]
      if kifu_file.present?
        self.kifu_body = kifu_file.read.toutf8
      end
    end

    if changes[:kifu_url]
      if kifu_url.present?
        self.kifu_body = open(kifu_url, &:read).toutf8
      end
    end

    true
  end

  before_save do
    if changes[:kifu_body]
      if kifu_body
        info = Bushido::Parser.parse(kifu_body)
        self.converted_ki2 = info.to_ki2
        self.converted_kif = info.to_kif
        self.converted_csa = info.to_csa
        self.turn_max = info.mediator.turn_max
        self.kifu_header = info.header
      end
    end
  end

  def to_param
    unique_key
  end
end
