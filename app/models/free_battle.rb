# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 棋譜入力 (free_battles as FreeBattle)
#
# |-------------------+--------------------+-------------+-------------+-----------------------------------+-------|
# | name              | desc               | type        | opts        | refs                              | index |
# |-------------------+--------------------+-------------+-------------+-----------------------------------+-------|
# | id                | ID                 | integer(8)  | NOT NULL PK |                                   |       |
# | key               | ユニークなハッシュ | string(255) | NOT NULL    |                                   | A!    |
# | kifu_url          | 棋譜URL            | string(255) |             |                                   |       |
# | kifu_body         | 棋譜               | text(65535) | NOT NULL    |                                   |       |
# | turn_max          | 手数               | integer(4)  | NOT NULL    |                                   |       |
# | meta_info         | 棋譜ヘッダー       | text(65535) | NOT NULL    |                                   |       |
# | battled_at        | Battled at         | datetime    | NOT NULL    |                                   |       |
# | created_at        | 作成日時           | datetime    | NOT NULL    |                                   |       |
# | updated_at        | 更新日時           | datetime    | NOT NULL    |                                   |       |
# | colosseum_user_id | Colosseum user     | integer(8)  |             | :owner_user => Colosseum::User#id | B     |
# | title             | タイトル           | string(255) |             |                                   |       |
# |-------------------+--------------------+-------------+-------------+-----------------------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# 【警告:リレーション欠如】Colosseum::Userモデルで has_many :free_battles, :foreign_key => :colosseum_user_id されていません
#--------------------------------------------------------------------------------

require "open-uri"

class FreeBattle < ApplicationRecord
  include ConvertMethods

  class << self
    def setup(options = {})
      super

      if Rails.env.development?
        unless exists?
          30.times { create!(kifu_body: "") }
        end
      end
    end
  end

  has_secure_token :key

  has_one_attached :kifu_file

  belongs_to :owner_user, :class_name => "Colosseum::User", :foreign_key => "colosseum_user_id", required: false

  def safe_title
    title.presence || "#{self.class.count.next}番目の何かの棋譜"
  end

  before_validation do
    self.title = safe_title

    self.kifu_body ||= ""

    if kifu_file.attached?
      v = kifu_file.download
      v = v.to_s.toutf8 rescue nil
      self.kifu_body = v
    end

    if changes[:kifu_url]
      if v = kifu_url.presence
        self.kifu_body = open(v, &:read).toutf8
        self.kifu_url = nil
      end
    end

    if changes[:kifu_body]
      if v = kifu_body.to_s.strip.presence
        if v.start_with?("http")
          self.kifu_body = open(v, &:read).toutf8
        end
      end
    end
  end

  before_save do
    if changes[:kifu_body]
      kifu_file.purge

      if kifu_body
        parser_exec
      end
    end
  end

  after_create do
    SlackAgent.chat_post_message(key: "棋譜入力", body: "#{title}")
  end

  concerning :TagMethods do
    included do
      acts_as_ordered_taggable_on :defense_tags
      acts_as_ordered_taggable_on :attack_tags
      acts_as_ordered_taggable_on :other_tags
    end
  end
end
