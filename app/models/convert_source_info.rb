# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 棋譜変換テーブル (convert_source_infos as ConvertSourceInfo)
#
# |-------------+--------------------+-------------+-------------+------+-------|
# | カラム名    | 意味               | タイプ      | 属性        | 参照 | INDEX |
# |-------------+--------------------+-------------+-------------+------+-------|
# | id          | ID                 | integer(8)  | NOT NULL PK |      |       |
# | unique_key  | ユニークなハッシュ | string(255) | NOT NULL    |      |       |
# | kifu_file   | 棋譜ファイル       | string(255) |             |      |       |
# | kifu_url    | 棋譜URL            | string(255) |             |      |       |
# | kifu_body   | 棋譜内容           | text(65535) |             |      |       |
# | turn_max    | 手数               | integer(4)  |             |      |       |
# | kifu_header | 棋譜ヘッダー       | text(65535) |             |      |       |
# | created_at  | 作成日時           | datetime    | NOT NULL    |      |       |
# | updated_at  | 更新日時           | datetime    | NOT NULL    |      |       |
# |-------------+--------------------+-------------+-------------+------+-------|

require "open-uri"

class ConvertSourceInfo < ApplicationRecord
  mount_uploader :kifu_file, AttachmentUploader

  has_many :converted_infos, as: :convertable, dependent: :destroy

  serialize :kifu_header

  before_validation do
    self.unique_key ||= SecureRandom.hex
    self.kifu_header ||= {}
    self.turn_max ||= 0
    self.kifu_body ||= ""

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
  end

  before_save do
    if changes[:kifu_body]
      if kifu_body
        info = Bushido::Parser.parse(kifu_body)
        converted_infos.destroy_all
        KifuFormatInfo.each do |e|
          converted_infos.build(converted_body: info.public_send("to_#{e.key}"), converted_format: e.key)
        end
        self.turn_max = info.mediator.turn_max
        self.kifu_header = info.header
      end
    end
  end

  def to_param
    unique_key
  end
end
