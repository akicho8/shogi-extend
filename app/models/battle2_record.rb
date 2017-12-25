# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 将棋ウォーズ対戦情報テーブル (battle2_records as Battle2Record)
#
# |--------------------+------------------+-------------+-------------+------------------+-------|
# | カラム名           | 意味             | タイプ      | 属性        | 参照             | INDEX |
# |--------------------+------------------+-------------+-------------+------------------+-------|
# | id                 | ID               | integer(8)  | NOT NULL PK |                  |       |
# | battle_key         | Battle2 key       | string(255) | NOT NULL    |                  | A!    |
# | battled_at         | Battle2d at       | datetime    | NOT NULL    |                  |       |
# | battle2_rule_key    | Battle2 rule key  | string(255) | NOT NULL    |                  | B     |
# | kifu_body            | Csa seq          | text(65535) | NOT NULL    |                  |       |
# | battle2_state_key   | Battle2 state key | string(255) | NOT NULL    |                  | C     |
# | win_battle2_user_id | Win battle user  | integer(8)  |             | => Battle2User#id | D     |
# | turn_max           | 手数             | integer(4)  | NOT NULL    |                  |       |
# | kifu_header        | 棋譜ヘッダー     | text(65535) | NOT NULL    |                  |       |
# | mountain_url       | 将棋山脈URL      | string(255) |             |                  |       |
# | created_at         | 作成日時         | datetime    | NOT NULL    |                  |       |
# | updated_at         | 更新日時         | datetime    | NOT NULL    |                  |       |
# |--------------------+------------------+-------------+-------------+------------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・【警告:リレーション欠如】Battle2Userモデルで has_many :battle2_records されていません
#--------------------------------------------------------------------------------

require "matrix"

class Battle2Record < ApplicationRecord
  include BattleRecord::ConvertMethods

  belongs_to :win_battle2_user, class_name: "Battle2User", optional: true # 勝者プレイヤーへのショートカット。引き分けの場合は入っていない。battle2_ships.win.battle2_user と同じ

  has_many :battle2_ships, -> { order(:position) }, dependent: :destroy, inverse_of: :battle2_record

  has_many :battle2_users, through: :battle2_ships do
    # 先手/後手プレイヤー
    def black
      first
    end

    def white
      second
    end
  end

  before_validation do
    # self.battle_key ||= SecureRandom.hex
    # self.battled_at ||= Time.current
    # self.battle2_rule_key ||= Battle2RuleInfo.first.key
    # self.battle2_state_key ||= "TORYO"

    # # "" から ten_min への変換
    # if battle2_rule_key
    #   self.battle2_rule_key = Battle2RuleInfo.fetch(battle2_rule_key).key
    # end

    # # キーは "(先手名)-(後手名)-(日付)" となっているので最後を開始日時とする
    # if battle_key
    #   self.battled_at ||= Time.zone.parse(battle_key.split("-").last)
    # end
  end

  with_options presence: true do
    validates :battle_key
    validates :battled_at
    validates :battle2_state_key
  end

  with_options allow_blank: true do
    validates :battle_key, uniqueness: true
  end

  validate do
    if battle2_ships.size != 2
      errors.add(:base, "対局者が2人いません : #{battle2_ships.size}")
    end
  end

  def to_param
    battle_key
  end

  def battle2_state_info
    Battle2StateInfo.fetch(battle2_state_key)
  end

  # has_many :converted_infos, as: :convertable, dependent: :destroy, inverse_of: :battle2_record

  concerning :ConvertHookMethos do
    # included do
    #   before_validation do
    #     if changes[:kifu_body] && kifu_body
    #       parser_exec
    #     end
    #   end
    # end

    class_methods do
      def kifu_dir
        Rails.root.join("../2chkifu").expand_path
        # Rails.root.join("2chkifu").expand_path
      end

      def kifu_files
        Pathname.glob("#{kifu_dir}/**/*.{ki2,KI2}").sort
      end

      def kifu_file_of(v)
        Pathname.glob("#{kifu_dir}/**/#{v}.{ki2,KI2}").first
      end

      # rails r 'Battle2Record.destroy_all; Battle2Record.all_import'
      def all_import(**params)
        files = kifu_files
        if v = params[:range]
          file = files[v]
        end
        files.each do |file|
          battle_key = file.basename(".*")
          begin
            single_battle2_import(battle_key)
          rescue => error
            p file
            p battle_key
            raise error
          end
        end
      end

      def single_battle2_import(battle_key)
        file = kifu_file_of(battle_key)

        record = new
        record.kifu_body = file.read.toutf8
        record.battle_key = file.basename(".*")
        record.parser_exec
        record.save!
      end
    end

    def after_parser_exec(info)
      tp info.header.to_h
      # |------------+------------------------|
      # |   開始日時 | 2003/09/08             |
      # |   終了日時 | 2003/09/09             |
      # |       棋戦 | 王位戦                 |
      # |       戦型 | その他の戦型           |
      # |       先手 | 羽生善治               |
      # |       後手 | 谷川浩司               |
      # |       場所 | 徳島県徳島市「渭水苑」 |
      # |   持ち時間 | 8時間                  |
      # | 先手の囲い | 菊水矢倉               |
      # | 後手の囲い |                        |
      # | 先手の戦型 |                        |
      # | 後手の戦型 |                        |
      # |     手合割 | 平手                   |
      # |------------+------------------------|

      # battle2_users = ["先手", "後手"].collect {|e|
      #   name = info.raw_header[e]
      #   # name = name.remove(*StaticBattle2GradeInfo.collect(&:name))
      #   # p name
      #   battle2_user = Battle2User.find_or_initialize_by(uid: name)
      #   # # battle2_grade = BattleGrade.find_by!(unique_key: e[:battle2_grade_key])
      #   # battle2_grade = Battle2Grade.first
      #   # battle2_user.update!(battle2_grade: battle2_grade) # 常にランクを更新する
      #   battle2_user.save!
      #   battle2_user
      # }

      self.other_tag_list = []

      self.battle2_state_key = info.last_action_info.key

      other_tag_list << battle_key
      other_tag_list << battle2_state_info.name
      other_tag_list << info.header["棋戦"]
      other_tag_list << info.header["持ち時間"]
      other_tag_list << info.header["掲載"]
      other_tag_list << info.header["場所"]

      if persisted?
        ships = battle2_ships.order(:position)
      else
        ships = info.mediator.players.count.times.collect { battle2_ships.build }
      end

      info.mediator.players.each.with_index do |player, i|
        all_names = info.header.to_simple_names_h.values.flatten

        # names = info.header.to_simple_names_h[player.call_name]

        # 名前をタグに全部つっこむ
        self.other_tag_list += info.header.to_names_h.values.flatten
        self.other_tag_list += info.header.to_simple_names_h.values.flatten

        # 名前
        all_names.each do |name|
          other_tag_list << name
          Battle2User.find_or_create_by(uid: name)
        end

        battle2_user = Battle2User.find_by!(uid: info.header.to_simple_names_h[player.call_name].first)

        battle2_grade = Battle2Grade.all.last

        battle2_ship = ships[i]
        battle2_ship.attributes = {
          battle2_user: battle2_user,
          battle2_grade: battle2_grade,
          judge_key: (player == info.mediator.reverse_player) ? :win : :lose,
          location_key: player.location.key,
        }

        self.other_tag_list += player.skill_set.normalized_defense_infos.collect(&:key)
        self.other_tag_list += player.skill_set.normalized_attack_infos.collect(&:key)

        battle2_ship.defense_tag_list = player.skill_set.normalized_defense_infos.collect(&:key)
        battle2_ship.attack_tag_list  = player.skill_set.normalized_attack_infos.collect(&:key)

        if player == info.mediator.reverse_player
          # SQLをシンプルにするために勝者だけ、所有者的な意味で、BattleRecord 自体に入れとく
          # いらんかったらあとでとる
          self.win_battle2_user = battle2_user
        end
      end

      # if persisted?
      #   players = battle2_ships.order(:position)
      # else
      #   players = battle2_ships
      # end

      self.battled_at = info.header["開始日時"]
      t = battled_at
      other_tag_list << t.strftime("%Y")
      other_tag_list << t.strftime("%Y/%m")
      other_tag_list << t.strftime("%Y/%m/%d")

      other_tag_list << turn_max
      other_tag_list << info.header["手合割"]
    end
  end

  concerning :HelperMethods do
    def winner_desuka?(battle2_user)
      if win_battle2_user
        win_battle2_user == battle2_user
      end
    end

    def lose_desuka?(battle2_user)
      if win_battle2_user
        win_battle2_user != battle2_user
      end
    end

    def win_lose_str(battle2_user)
      if battle2_ships.all? { |e| e.judge_key == "draw" }
        Fa.icon_tag(:minus, :class => "icon_hidden")
      else
        battle2_ship = battle2_ships.to_a.find {|e| e.judge_key == "win" }

        names = kifu_header[:to_simple_names_h].values[battle2_ship.location.code]
        if names.include?(battle2_user.uid)
          Fa.icon_tag(:circle_o)
        else
          Fa.icon_tag(:times)
        end
      end
    end

    def myself(user)
      index = kifu_header[:to_simple_names_h].values.index { |e| e.include?(user.uid) }
      battle2_ships[index]
    end

    def rival(user)
      index = kifu_header[:to_simple_names_h].values.index { |e| e.include?(user.uid) }
      battle2_ships.reverse[index]
    end

    # >> |----------+------------------------------------------------------------------------|
    # >> | 開始日時 | 2008/11/09                                                             |
    # >> |     棋戦 | その他の棋戦                                                           |
    # >> |     戦型 | 矢倉                                                                   |
    # >> |     先手 | 清水市代＆フレデリック・ポティエ                                       |
    # >> |     後手 | 矢内理絵子＆ヨッヘン・ドレクスラー                                     |
    # >> |     場所 | 山形県天童市「市民文化会館」                                           |
    # >> | 持ち時間 | 初手から1手30秒未満                                                    |
    # >> |   放映日 | 2008/11/30                                                             |
    # >> | 棋戦詳細 | ["第34回", "将棋", "の日", "女流", "棋士", "外国選手", "ペア", "将棋"] |
    # >> | 先手詳細 | ["清水市代", "フレデリック", "ポティエ"]                               |
    # >> | 後手詳細 | ["矢内理絵子", "ヨッヘン", "ドレクスラー"]                             |
    # >> |----------+------------------------------------------------------------------------|
    def header_detail(h)
      row = kifu_header[:to_meta_h].dup
      row.each do |k, v|
        case k
        when /の(囲い|戦型)$/
          # row[k] = v.collect { |e| h.link_to(e, [:formation_article, id: e]) }.join(" ").html_safe
          row[k] = v.collect { |e| h.link_to(e, h.pro_query_search_path(e)) }.join(" ").html_safe
        when "棋戦詳細"
          row[k] = kifu_header[:to_kisen_a].collect { |e| h.link_to(e, h.pro_query_search_path(e)) }.join(" ").html_safe
        when "場所"
          row[k] = h.link_to(v, h.pro_query_search_path(v))
        when "掲載"
          row[k] = h.link_to(v, h.pro_query_search_path(v))
        when "持ち時間"
          row[k] = h.link_to(v, h.pro_query_search_path(v))
        when "手合割"
          row[k] = h.link_to(v, h.pro_query_search_path(v))
        when /.手\z/
          row[k] = v.collect { |e| h.link_to(e, h.pro_query_search_path(e)) }.join(" ").html_safe
        when /.手詳細/
          row[k] = v.collect { |e| h.link_to(e, h.pro_query_search_path(e)) }.join(" ").html_safe
        when "棋戦"
          row[k] = h.link_to(v, h.pro_query_search_path(v))
        when "戦型"
          row[k] = h.link_to(v, h.pro_query_search_path(v))
        end
      end
      row
    end
  end

  concerning :ImportMethods do
    class_methods do
    end
  end

  concerning :TagMethods do
    included do
      acts_as_ordered_taggable_on :defense_tags
      acts_as_ordered_taggable_on :attack_tags
      acts_as_ordered_taggable_on :other_tags
    end
  end
end
