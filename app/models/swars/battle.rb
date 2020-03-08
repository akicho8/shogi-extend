# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 将棋ウォーズ対戦情報 (swars_battles as Swars::Battle)
#
# |-------------------+------------------+----------------+-------------+------+-------|
# | name              | desc             | type           | opts        | refs | index |
# |-------------------+------------------+----------------+-------------+------+-------|
# | id                | ID               | integer(8)     | NOT NULL PK |      |       |
# | key               | 対局ユニークキー | string(255)    | NOT NULL    |      | A!    |
# | battled_at        | 対局日時         | datetime       | NOT NULL    |      | E     |
# | rule_key          | ルール           | string(255)    | NOT NULL    |      | B     |
# | csa_seq           | 棋譜             | text(16777215) | NOT NULL    |      |       |
# | final_key         | 結末             | string(255)    | NOT NULL    |      | C     |
# | win_user_id       | 勝者             | integer(8)     |             |      | D     |
# | turn_max          | 手数             | integer(4)     | NOT NULL    |      | F     |
# | meta_info         | メタ情報         | text(16777215) | NOT NULL    |      |       |
# | last_accessd_at   | 最終アクセス日時 | datetime       | NOT NULL    |      |       |
# | access_logs_count | アクセス数       | integer(4)     | DEFAULT(0)  |      |       |
# | created_at        | 作成日時         | datetime       | NOT NULL    |      |       |
# | updated_at        | 更新日時         | datetime       | NOT NULL    |      |       |
# | preset_key        | 手合割           | string(255)    | NOT NULL    |      |       |
# | start_turn        | 開始局面         | integer(4)     |             |      |       |
# | critical_turn     | 開戦             | integer(4)     |             |      | G     |
# | saturn_key        | 公開範囲         | string(255)    | NOT NULL    |      | H     |
# | sfen_body         | SFEN形式棋譜     | string(8192)   |             |      |       |
# | image_turn        | OGP画像の局面    | integer(4)     |             |      |       |
# | outbreak_turn     | Outbreak turn    | integer(4)     |             |      |       |
# |-------------------+------------------+----------------+-------------+------+-------|

require "matrix"

module Swars
  class Battle < ApplicationRecord
    include BattleModelSharedMethods
    include ImportMethods
    include ConvertHookMethods

    belongs_to :win_user, class_name: "User", optional: true # 勝者プレイヤーへのショートカット。引き分けの場合は入っていない。memberships.win.user と同じ

    has_many :memberships, -> { order(:position) }, dependent: :destroy, inverse_of: :battle

    has_many :access_logs, dependent: :destroy # アクセスログみたいもの

    has_many :users, through: :memberships

    before_validation on: :create do
      self.key ||= SecureRandom.hex
      self.rule_key ||= :ten_min

      # "" から ten_min への変換
      if rule_key
        self.rule_key = RuleInfo.fetch(rule_key).key
      end

      # キーは "(先手名)-(後手名)-(日付)" となっているので最後を開始日時とする
      if key
        self.battled_at ||= (Time.zone.parse(key.split("-").last) rescue nil)
      end

      self.last_accessd_at ||= Time.current
      self.battled_at ||= Time.current
      self.final_key ||= :TORYO
      self.preset_key ||= :"平手"
    end

    with_options presence: true do
      validates :key
      validates :battled_at
      validates :rule_key
      validates :final_key
      validates :preset_key
    end

    with_options allow_blank: true do
      validates :key, uniqueness: true
      validates :preset_key, inclusion: Bioshogi::PresetInfo.keys.collect(&:to_s)
      validates :final_key, inclusion: FinalInfo.keys.collect(&:to_s)
    end

    def to_param
      key
    end

    def rule_info
      RuleInfo.fetch(rule_key)
    end

    def final_info
      FinalInfo.fetch(final_key)
    end

    def preset_info
      Bioshogi::PresetInfo.fetch(preset_key)
    end

    def battle_decorator_class
      BattleDecorator::SwarsBattleDecorator
    end

    # 将棋ウォーズの形式はCSAなのでパーサーを明示すると理論上は速くなる
    def parser_class
      Bioshogi::Parser::CsaParser
    end

    concerning :SummaryMethods do
      def total_seconds
        @total_seconds ||= memberships.sum(&:total_seconds)
      end

      def end_at
        @end_at ||= battled_at + total_seconds.seconds
      end
    end

    concerning :HelperMethods do
      class_methods do
        def battle_url_extract(str)
          if url = URI.extract(str, ["http", "https"]).first
            if url.match?(%r{\.heroz\.jp/games/})
              url
            end
          end
        end

        def battle_key_extract(str)
          if url = battle_url_extract(str)
            URI(url).path.split("/").last
          end
        end
      end

      def swars_tweet_text
        "将棋ウォーズ棋譜(#{title}) #{official_swars_battle_url} #shogiwars #将棋"
      end

      def official_swars_battle_url
        Rails.application.routes.url_helpers.official_swars_battle_url(self)
      end

      # def header_detail(h)
      #   if v = super
      #     v.merge("場所" => h.link_to(key, official_swars_battle_url, target: "_self"))
      #   end
      # end

      def title
        memberships.collect(&:name_with_grade).join(" 対 ")
      end

      def description
        out = []
        out << "将棋ウォーズ#{rule_info.long_name}"
        # out << final_info.name
        out << memberships.collect { |e| (e.tag_names_for(:attack).presence || ["その他"]).join(" ") }.join(" vs ")
        out.join(" ")
      end
    end

    def self.rule_key_bugfix_process
      c = 0
      Swars::Battle.where(Swars::Battle.arel_table[:created_at].gteq("2020-01-17".to_time)).find_each do |battle|
        if battle.rule_key == "ten_min"
          if ary = battle.csa_seq.first
            v = ary.last
            rule_key = nil
            case
            when v <= 180
              rule_key = "three_min"
            when v >= 1000
              rule_key = "ten_sec"
            end
            if rule_key
              # p battle.id
              battle.update!(rule_key: rule_key)
              # print "."
              c += 1
              # break
            end
          end
        end
      end
      SlackAgent.message_send(key: "rule_key_bugfix_process", body: c.to_s)
    end
  end
end
