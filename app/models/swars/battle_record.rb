# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 将棋ウォーズ対戦情報テーブル (battle_records as Swars::BattleRecord)
#
# |---------------------------------------+---------------------------------------+-------------+-------------+-----------------------+-------|
# | カラム名                              | 意味                                  | タイプ      | 属性        | 参照                  | INDEX |
# |---------------------------------------+---------------------------------------+-------------+-------------+-----------------------+-------|
# | id                                    | ID                                    | integer(8)  | NOT NULL PK |                       |       |
# | battle_key                            | Battle key                            | string(255) | NOT NULL    |                       | A!    |
# | battled_at                            | Battled at                            | datetime    | NOT NULL    |                       |       |
# | battle_rule_key                       | Battle rule key                       | string(255) | NOT NULL    |                       | B     |
# | csa_seq                               | Csa seq                               | text(65535) | NOT NULL    |                       |       |
# | battle_state_key                      | Battle state key                      | string(255) | NOT NULL    |                       | C     |
# | win_battle_user_id              | Win swars battle user                 | integer(8)  |             | => Swars::BattleUser#id | D     |
# | turn_max                              | 手数                                  | integer(4)  | NOT NULL    |                       |       |
# | meta_info                             | 棋譜ヘッダー                          | text(65535) | NOT NULL    |                       |       |
# | mountain_url                          | 将棋山脈URL                           | string(255) |             |                       |       |
# | last_accessd_at                       | Last accessd at                       | datetime    | NOT NULL    |                       |       |
# | battle_record_access_logs_count | Swars battle record access logs count | integer(4)  | DEFAULT(0)  |                       |       |
# | created_at                            | 作成日時                              | datetime    | NOT NULL    |                       |       |
# | updated_at                            | 更新日時                              | datetime    | NOT NULL    |                       |       |
# |---------------------------------------+---------------------------------------+-------------+-------------+-----------------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・【警告:リレーション欠如】Swars::BattleUserモデルで has_many :battle_records されていません
#--------------------------------------------------------------------------------

require "matrix"

class Swars::BattleRecord < ApplicationRecord
  include ConvertMethods

  belongs_to :win_battle_user, class_name: "Swars::BattleUser", optional: true # 勝者プレイヤーへのショートカット。引き分けの場合は入っていない。battle_ships.win.battle_user と同じ

  has_many :battle_ships, -> { order(:position) }, dependent: :destroy, inverse_of: :battle_record
  delegate :rival, :myself, to: :battle_ships

  has_many :battle_record_access_logs, dependent: :destroy # アクセスログみたいもの

  has_many :battle_users, through: :battle_ships do
    # 先手/後手プレイヤー
    def black
      first
    end

    def white
      second
    end
  end

  before_validation on: :create do
    self.last_accessd_at ||= Time.current

    # "" から ten_min への変換
    if battle_rule_key
      self.battle_rule_key = Swars::BattleRuleInfo.fetch(battle_rule_key).key
    end

    # キーは "(先手名)-(後手名)-(日付)" となっているので最後を開始日時とする
    if battle_key
      self.battled_at ||= Time.zone.parse(battle_key.split("-").last)
    end
  end

  with_options presence: true do
    validates :battle_key
    validates :battled_at
    validates :battle_rule_key
    validates :battle_state_key
  end

  with_options allow_blank: true do
    validates :battle_key, uniqueness: true
  end

  validate do
    if battle_ships.size != 2
      errors.add(:base, "対局者が2人いません : #{battle_ships.size}")
    end
  end

  def to_param
    battle_key
  end

  def swars_battle_rule_info
    Swars::BattleRuleInfo.fetch(battle_rule_key)
  end

  def swars_battle_state_info
    Swars::BattleStateInfo.fetch(battle_state_key)
  end

  concerning :ConvertHookMethos do
    included do
      serialize :csa_seq

      before_validation do
      end

      before_save do
        if changes[:csa_seq] && csa_seq
          parser_exec
        end
      end
    end

    def kifu_body
      if persisted?
        players = battle_ships.order(:position)
      else
        players = battle_ships
      end

      s = []
      s << ["N+", players.first.name_with_grade].join
      s << ["N-", players.second.name_with_grade].join
      s << ["$START_TIME", battled_at.to_s(:csa_ymdhms)] * ":"
      s << ["$EVENT", "将棋ウォーズ(#{swars_battle_rule_info.long_name})"] * ":"
      s << ["$TIME_LIMIT", swars_battle_rule_info.csa_time_limit] * ":"

      # $OPENING は 戦型 のことで、これが判明するのはパースの後なのでいまはわからない。
      # それに自動的にあとから埋められるのでここは指定しなくてよい
      # s << "$OPENING:不明"

      # 平手なので先手から
      s << "+"

      # 残り時間の並びから使用時間を求めつつ指し手と一緒に並べていく
      life = [swars_battle_rule_info.life_time] * battle_ships.size
      csa_seq.each.with_index do |(op, t), i|
        i = i.modulo(life.size)
        used = life[i] - t
        life[i] = t
        s << "#{op}"
        s << "T#{used}"
      end

      s << "%#{swars_battle_state_info.last_action_key}"
      s.join("\n") + "\n"
    end

    def parser_exec_after(info)
      # 囲い対決などに使う
      if true
        if persisted?
          ships = battle_ships.order(:position)
        else
          ships = battle_ships
        end
        info.mediator.players.each.with_index do |player, i|
          battle_ship = ships[i]
          battle_ship.defense_tag_list = player.skill_set.defense_infos.normalize.collect(&:key)
          battle_ship.attack_tag_list  = player.skill_set.attack_infos.normalize.collect(&:key)
        end
      end

      other_tag_list << swars_battle_rule_info.name
      other_tag_list << swars_battle_state_info.name
    end
  end

  concerning :HelperMethods do
    def winner_desuka?(battle_user)
      if win_battle_user
        win_battle_user == battle_user
      end
    end

    def lose_desuka?(battle_user)
      if win_battle_user
        win_battle_user != battle_user
      end
    end

    def win_lose_str(battle_user)
      if win_battle_user
        if winner_desuka?(battle_user)
          Fa.icon_tag(:far, :circle)
        else
          Fa.icon_tag(:fas, :times)
        end
      else
        Fa.icon_tag(:fas, :minus, :class => "icon_hidden")
      end
    end

    def wars_tweet_body
      vs = battle_ships.collect(&:name_with_grade).join(" 対 ")
      url = Rails.application.routes.url_helpers.swars_real_battle_url(self, tw: 1)
      "将棋ウォーズ棋譜(#{vs}) #{url} #shogiwars #将棋"
    end
  end

  concerning :ImportMethods do
    class_methods do
      def run(*args, **params, &block)
        import(*args, params, &block)
      end

      def old_record_destroy(**params)
        params = {
          time: 1.months.ago,
        }.merge(params)

        all.where(arel_table[:last_accessd_at].lteq(params[:time])).destroy_all
      end

      def remake(**params)
        params = {
          limit: 256,
        }.merge(params)

        c = Hash.new(0)
        all.order(last_accessd_at: :desc).limit(params[:limit]).find_each do |e|
          e.parser_exec
          c[e.changed?] += 1
          print(e.changed? ? 'U' : '.')
          e.save!
        end
        p c
      end

      def import(key, **params, &block)
        counts = -> { Vector[Swars::BattleUser.count, Swars::BattleRecord.count] }
        old = counts.call
        begin
          p [Time.current.to_s(:ymdhms), key, 'begin', old.to_a]
          if block_given?
            yield
          else
            public_send(key, params)
          end
        rescue => error
          raise error
        ensure
          v = counts.call
          p [Time.current.to_s(:ymdhms), key, 'end__', v.to_a, (v - old).to_a, error].compact
        end
      end

      # Swars::BattleRecord.reception_import(limit: 10, sleep: 5)
      def reception_import(**params)
        Swars::BattleUser.where.not(last_reception_at: nil).order(last_reception_at: :desc).limit(params[:limit] || 1).each do |battle_user|
          basic_import(params.merge(user_key: battle_user.user_key))
        end
      end

      # Swars::BattleRecord.expert_import
      # Swars::BattleRecord.expert_import(page_max: 3, sleep: 5)
      def expert_import(**params)
        swars_battle_agent.legend_battle_user_keys.each do |battle_user_key|
          basic_import(params.merge(user_key: battle_user_key))
        end
      end

      # Swars::BattleRecord.conditional_import(limit: 10, page_max: 3, sleep: 5, battle_grade_key_gteq: "初段") # (10 * (3*10) * 5) / 60 = 25 min
      def conditional_import(**params)
        # 最近対局した初段以上のプレイヤー limit 人取得
        s = Swars::BattleShip.all
        # 初段以上の場合
        if true
          if v = params[:battle_grade_key_gteq]
            priority = Swars::BattleGradeInfo.fetch(v).priority
            s = s.joins(battle_user: :battle_grade).where(Swars::BattleGrade.arel_table[:priority].lteq(priority))
          end
        end
        s = s.group(:battle_user_id).select(:battle_user_id)
        s = s.joins(:battle_record).order("max(#{Swars::BattleRecord.table_name}.battled_at) desc")
        s = s.limit(params[:limit] || 1)
        # SELECT  `battle_ships`.`battle_user_id` FROM `battle_ships` INNER JOIN `battle_users` ON `battle_users`.`id` = `battle_ships`.`battle_user_id` INNER JOIN `battle_grades` ON `battle_grades`.`id` = `battle_users`.`battle_grade_id` INNER JOIN `battle_records` ON `battle_records`.`id` = `battle_ships`.`battle_record_id` WHERE (`battle_grades`.`priority` <= 8) GROUP BY `battle_ships`.`battle_user_id` ORDER BY max(battle_records.battled_at) desc LIMIT 1
        battle_user_ids = s.pluck(:battle_user_id)

        # 最近取り込んだプレイヤー limit 人取得
        # battle_user_ids = Swars::BattleShip.group(:battle_user_id).select(:battle_user_id).order("max(created_at) desc").limit(params[:limit] || 1).pluck(:battle_user_id)

        battle_users = Swars::BattleUser.find(battle_user_ids)

        battle_users.each do |battle_user|
          basic_import(params.merge(user_key: battle_user.user_key))
        end
      end

      # Swars::BattleRecord.basic_import(user_key: "DarkPonamin9")
      # Swars::BattleRecord.basic_import(user_key: "micro77")
      # Swars::BattleRecord.basic_import(user_key: "micro77", page_max: 3)
      def basic_import(**params)
        Swars::BattleRuleInfo.each do |e|
          multiple_battle_import(params.merge(gtype: e.swars_real_key))
        end
      end

      # Swars::BattleRecord.multiple_battle_import(user_key: "chrono_", gtype: "")
      def multiple_battle_import(**params)
        (params[:page_max] || 1).times do |i|
          list = swars_battle_agent.index_get(params.merge(page_index: i))

          # もうプレイしていない人のページは履歴が空なのでクロールを完全にやめる (もしくは過去のページに行きすぎたので中断)
          if list.empty?
            break
          end

          list.each do |history|
            battle_key = history[:battle_key]

            # すでに取り込んでいるならスキップ
            if Swars::BattleRecord.where(battle_key: battle_key).exists?
              next
            end

            # # フィルタ機能
            # if true
            #   # 初段以上の指定がある場合
            #   if v = params[:battle_grade_key_gteq]
            #     v = Swars::BattleGradeInfo.fetch(v)
            #     # 取得してないときもあるため
            #     if battle_user_infos = history[:battle_user_infos]
            #       # 両方初段以上ならOK
            #       if battle_user_infos.all? { |e| Swars::BattleGradeInfo.fetch(e[:battle_grade_key]).priority <= v.priority }
            #       else
            #         next
            #       end
            #     end
            #   end
            # end

            single_battle_import(battle_key)
            sleep(params[:sleep].to_i)
          end
        end
      end

      def single_battle_import(battle_key)
        # 登録済みなのでスキップ
        if Swars::BattleRecord.where(battle_key: battle_key).exists?
          return
        end

        info = swars_battle_agent.record_get(battle_key)

        # 対局中や引き分けのときは棋譜がないのでスキップ
        unless info[:st_done]
          return
        end

        # # 引き分けを考慮すると急激に煩雑になるため取り込まない
        # # ここで DRAW_SENNICHI も弾く
        # unless info[:__battle_state_key].match?(/(SENTE|GOTE)_WIN/)
        #   return
        # end

        battle_users = info[:battle_user_infos].collect do |e|
          Swars::BattleUser.find_or_initialize_by(user_key: e[:user_key]).tap do |battle_user|
            battle_grade = Swars::BattleGrade.find_by!(unique_key: e[:battle_grade_key])
            battle_user.battle_grade = battle_grade # 常にランクを更新する
            begin
              battle_user.save!
            rescue ActiveRecord::RecordNotUnique
            end
          end
        end

        battle_record = Swars::BattleRecord.new({
            battle_key: info[:battle_key],
            battle_rule_key: info.dig(:gamedata, :gtype),
            csa_seq: info[:csa_seq],
          })

        if md = info[:__battle_state_key].match(/\A(?<prefix>\w+)_WIN_(?<battle_state_key>\w+)/)
          winner_index = md[:prefix] == "SENTE" ? 0 : 1
          battle_record.battle_state_key = md[:battle_state_key]
        else
          winner_index = nil
          battle_record.battle_state_key = info[:__battle_state_key]
        end

        info[:battle_user_infos].each.with_index do |e, i|
          battle_user = Swars::BattleUser.find_by!(user_key: e[:user_key])
          battle_grade = Swars::BattleGrade.find_by!(unique_key: e[:battle_grade_key])

          if winner_index
            judge_key = (i == winner_index) ? :win : :lose
          else
            judge_key = :draw
          end

          battle_record.battle_ships.build(battle_user:  battle_user, battle_grade: battle_grade, judge_key: judge_key, location_key: Warabi::Location.fetch(i).key)
        end

        # SQLをシンプルにするために勝者だけ、所有者的な意味で、Swars::BattleRecord 自体に入れとく
        # いらんかったらあとでとる
        if winner_index
          battle_record.win_battle_user = battle_record.battle_ships[winner_index].battle_user
        end

        begin
          battle_record.save!
        rescue ActiveRecord::RecordNotUnique
        end
      end

      private

      def swars_battle_agent
        @swars_battle_agent ||= Swars::BattleAgent.new
      end
    end
  end
end
