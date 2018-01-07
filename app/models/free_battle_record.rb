# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 棋譜変換テーブル (free_battle_records as FreeBattleRecord)
#
# |--------------+--------------------+-------------+-------------+------+-------|
# | カラム名     | 意味               | タイプ      | 属性        | 参照 | INDEX |
# |--------------+--------------------+-------------+-------------+------+-------|
# | id           | ID                 | integer(8)  | NOT NULL PK |      |       |
# | unique_key   | ユニークなハッシュ | string(255) | NOT NULL    |      | A     |
# | kifu_file    | 棋譜ファイル       | string(255) |             |      |       |
# | kifu_url     | 棋譜URL            | string(255) |             |      |       |
# | kifu_body    | 棋譜内容           | text(65535) | NOT NULL    |      |       |
# | turn_max     | 手数               | integer(4)  | NOT NULL    |      |       |
# | meta_info    | 棋譜ヘッダー       | text(65535) | NOT NULL    |      |       |
# | mountain_url | 将棋山脈URL        | string(255) |             |      |       |
# | battled_at   | Battled at         | datetime    | NOT NULL    |      |       |
# | created_at   | 作成日時           | datetime    | NOT NULL    |      |       |
# | updated_at   | 更新日時           | datetime    | NOT NULL    |      |       |
# |--------------+--------------------+-------------+-------------+------+-------|

require "open-uri"

class FreeBattleRecord < ApplicationRecord
  include ConvertMethods

  mount_uploader :kifu_file, AttachmentUploader

  before_validation do
    self.unique_key ||= SecureRandom.hex
    self.kifu_body ||= ""

    if changes[:kifu_file]
      if v = kifu_file.presence
        self.kifu_body = v.read.toutf8
      end
    end

    if changes[:kifu_url]
      if v = kifu_url.presence
        self.kifu_body = open(v, &:read).toutf8
      end
    end

    if changes[:kifu_body]
      if v = kifu_body.to_s.strip.presence
        if v.match?("http")
          self.kifu_body = open(v, &:read).toutf8
        end
      end
    end
  end

  before_save do
    if changes[:kifu_body]
      if kifu_body
        parser_exec
      end
    end
  end

  def to_param
    unique_key
  end

  concerning :TagMethods do
    included do
      acts_as_ordered_taggable_on :defense_tags
      acts_as_ordered_taggable_on :attack_tags
      acts_as_ordered_taggable_on :other_tags
    end
  end
end
