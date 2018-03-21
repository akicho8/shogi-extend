# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 将棋ウォーズ対戦情報テーブル (swars_battle_records as SwarsBattleRecord)
#
# |--------------------------+-----------------------+-------------+-------------+-----------------------+-------|
# | カラム名                 | 意味                  | タイプ      | 属性        | 参照                  | INDEX |
# |--------------------------+-----------------------+-------------+-------------+-----------------------+-------|
# | id                       | ID                    | integer(8)  | NOT NULL PK |                       |       |
# | battle_key               | Battle key            | string(255) | NOT NULL    |                       | A!    |
# | battled_at               | Battled at            | datetime    | NOT NULL    |                       |       |
# | battle_rule_key          | Battle rule key       | string(255) | NOT NULL    |                       | B     |
# | csa_seq                  | Csa seq               | text(65535) | NOT NULL    |                       |       |
# | battle_state_key         | Battle state key      | string(255) | NOT NULL    |                       | C     |
# | win_swars_battle_user_id | Win swars battle user | integer(8)  |             | => SwarsBattleUser#id | D     |
# | turn_max                 | 手数                  | integer(4)  | NOT NULL    |                       |       |
# | meta_info                | 棋譜ヘッダー          | text(65535) | NOT NULL    |                       |       |
# | mountain_url             | 将棋山脈URL           | string(255) |             |                       |       |
# | created_at               | 作成日時              | datetime    | NOT NULL    |                       |       |
# | updated_at               | 更新日時              | datetime    | NOT NULL    |                       |       |
# |--------------------------+-----------------------+-------------+-------------+-----------------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・【警告:リレーション欠如】SwarsBattleUserモデルで has_many :swars_battle_records されていません
#--------------------------------------------------------------------------------

require "matrix"

class SwarsBattleRecord < ApplicationRecord
  include ConvertMethods

  belongs_to :win_swars_battle_user, class_name: "SwarsBattleUser", optional: true # 勝者プレイヤーへのショートカット。引き分けの場合は入っていない。swars_battle_ships.win.swars_battle_user と同じ

  has_many :swars_battle_ships, -> { order(:position) }, dependent: :destroy, inverse_of: :swars_battle_record
  delegate :rival, :myself, to: :swars_battle_ships

  has_many :swars_battle_record_access_logs, dependent: :destroy # アクセスログみたいもの

  has_many :swars_battle_users, through: :swars_battle_ships do
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
      self.battle_rule_key = SwarsBattleRuleInfo.fetch(battle_rule_key).key
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
    if swars_battle_ships.size != 2
      errors.add(:base, "対局者が2人いません : #{swars_battle_ships.size}")
    end
  end

  def to_param
    battle_key
  end

  def swars_battle_rule_info
    SwarsBattleRuleInfo.fetch(battle_rule_key)
  end

  def swars_battle_state_info
    SwarsBattleStateInfo.fetch(battle_state_key)
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
        players = swars_battle_ships.order(:position)
      else
        players = swars_battle_ships
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
      life = [swars_battle_rule_info.life_time] * swars_battle_ships.size
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
          ships = swars_battle_ships.order(:position)
        else
          ships = swars_battle_ships
        end
        info.mediator.players.each.with_index do |player, i|
          swars_battle_ship = ships[i]
          swars_battle_ship.defense_tag_list = player.skill_set.defense_infos.normalize.collect(&:key)
          swars_battle_ship.attack_tag_list  = player.skill_set.attack_infos.normalize.collect(&:key)
        end
      end

      other_tag_list << swars_battle_rule_info.name
      other_tag_list << swars_battle_state_info.name
    end
  end

  concerning :HelperMethods do
    def winner_desuka?(swars_battle_user)
      if win_swars_battle_user
        win_swars_battle_user == swars_battle_user
      end
    end

    def lose_desuka?(swars_battle_user)
      if win_swars_battle_user
        win_swars_battle_user != swars_battle_user
      end
    end

    def win_lose_str(swars_battle_user)
      if win_swars_battle_user
        if winner_desuka?(swars_battle_user)
          Fa.icon_tag(:far, :circle)
        else
          Fa.icon_tag(:fas, :times)
        end
      else
        Fa.icon_tag(:fas, :minus, :class => "icon_hidden")
      end
    end

    def wars_tweet_body
      vs = swars_battle_ships.collect(&:name_with_grade).join(" 対 ")
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
        counts = -> { Vector[SwarsBattleUser.count, SwarsBattleRecord.count] }
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

      # SwarsBattleRecord.reception_import(limit: 10, sleep: 5)
      def reception_import(**params)
        SwarsBattleUser.where.not(last_reception_at: nil).order(last_reception_at: :desc).limit(params[:limit] || 1).each do |swars_battle_user|
          basic_import(params.merge(user_key: swars_battle_user.user_key))
        end
      end

      # SwarsBattleRecord.expert_import
      # SwarsBattleRecord.expert_import(page_max: 3, sleep: 5)
      def expert_import(**params)
        swars_battle_agent.legend_swars_battle_user_keys.each do |swars_battle_user_key|
          basic_import(params.merge(user_key: swars_battle_user_key))
        end
      end

      # SwarsBattleRecord.conditional_import(limit: 10, page_max: 3, sleep: 5, swars_battle_grade_key_gteq: "初段") # (10 * (3*10) * 5) / 60 = 25 min
      def conditional_import(**params)
        # 最近対局した初段以上のプレイヤー limit 人取得
        s = SwarsBattleShip.all
        # 初段以上の場合
        if true
          if v = params[:swars_battle_grade_key_gteq]
            priority = SwarsBattleGradeInfo.fetch(v).priority
            s = s.joins(swars_battle_user: :swars_battle_grade).where(SwarsBattleGrade.arel_table[:priority].lteq(priority))
          end
        end
        s = s.group(:swars_battle_user_id).select(:swars_battle_user_id)
        s = s.joins(:swars_battle_record).order("max(swars_battle_records.battled_at) desc")
        s = s.limit(params[:limit] || 1)
        # SELECT  `swars_battle_ships`.`swars_battle_user_id` FROM `swars_battle_ships` INNER JOIN `swars_battle_users` ON `swars_battle_users`.`id` = `swars_battle_ships`.`swars_battle_user_id` INNER JOIN `swars_battle_grades` ON `swars_battle_grades`.`id` = `swars_battle_users`.`swars_battle_grade_id` INNER JOIN `swars_battle_records` ON `swars_battle_records`.`id` = `swars_battle_ships`.`swars_battle_record_id` WHERE (`swars_battle_grades`.`priority` <= 8) GROUP BY `swars_battle_ships`.`swars_battle_user_id` ORDER BY max(swars_battle_records.battled_at) desc LIMIT 1
        swars_battle_user_ids = s.pluck(:swars_battle_user_id)

        # 最近取り込んだプレイヤー limit 人取得
        # swars_battle_user_ids = SwarsBattleShip.group(:swars_battle_user_id).select(:swars_battle_user_id).order("max(created_at) desc").limit(params[:limit] || 1).pluck(:swars_battle_user_id)

        swars_battle_users = SwarsBattleUser.find(swars_battle_user_ids)

        swars_battle_users.each do |swars_battle_user|
          basic_import(params.merge(user_key: swars_battle_user.user_key))
        end
      end

      # SwarsBattleRecord.basic_import(user_key: "DarkPonamin9")
      # SwarsBattleRecord.basic_import(user_key: "micro77")
      # SwarsBattleRecord.basic_import(user_key: "micro77", page_max: 3)
      def basic_import(**params)
        SwarsBattleRuleInfo.each do |e|
          multiple_battle_import(params.merge(gtype: e.swars_real_key))
        end
      end

      # SwarsBattleRecord.multiple_battle_import(user_key: "chrono_", gtype: "")
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
            if SwarsBattleRecord.where(battle_key: battle_key).exists?
              next
            end

            # # フィルタ機能
            # if true
            #   # 初段以上の指定がある場合
            #   if v = params[:swars_battle_grade_key_gteq]
            #     v = SwarsBattleGradeInfo.fetch(v)
            #     # 取得してないときもあるため
            #     if swars_battle_user_infos = history[:swars_battle_user_infos]
            #       # 両方初段以上ならOK
            #       if swars_battle_user_infos.all? { |e| SwarsBattleGradeInfo.fetch(e[:swars_battle_grade_key]).priority <= v.priority }
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
        if SwarsBattleRecord.where(battle_key: battle_key).exists?
          return
        end

        info = swars_battle_agent.record_get(battle_key)

        # 対局中や引き分けのときは棋譜がないのでスキップ
        unless info[:battle_done]
          return
        end

        # # 引き分けを考慮すると急激に煩雑になるため取り込まない
        # # ここで DRAW_SENNICHI も弾く
        # unless info[:__battle_state_key].match?(/(SENTE|GOTE)_WIN/)
        #   return
        # end

        swars_battle_users = info[:swars_battle_user_infos].collect do |e|
          SwarsBattleUser.find_or_initialize_by(user_key: e[:user_key]).tap do |swars_battle_user|
            swars_battle_grade = SwarsBattleGrade.find_by!(unique_key: e[:swars_battle_grade_key])
            swars_battle_user.swars_battle_grade = swars_battle_grade # 常にランクを更新する
            begin
              swars_battle_user.save!
            rescue ActiveRecord::RecordNotUnique
            end
          end
        end

        swars_battle_record = SwarsBattleRecord.new({
            battle_key: info[:battle_key],
            battle_rule_key: info.dig(:gamedata, :gtype),
            csa_seq: info[:csa_seq],
          })

        if md = info[:__battle_state_key].match(/\A(?<prefix>\w+)_WIN_(?<battle_state_key>\w+)/)
          winner_index = md[:prefix] == "SENTE" ? 0 : 1
          swars_battle_record.battle_state_key = md[:battle_state_key]
        else
          winner_index = nil
          swars_battle_record.battle_state_key = info[:__battle_state_key]
        end

        info[:swars_battle_user_infos].each.with_index do |e, i|
          swars_battle_user = SwarsBattleUser.find_by!(user_key: e[:user_key])
          swars_battle_grade = SwarsBattleGrade.find_by!(unique_key: e[:swars_battle_grade_key])

          if winner_index
            judge_key = (i == winner_index) ? :win : :lose
          else
            judge_key = :draw
          end

          swars_battle_record.swars_battle_ships.build(swars_battle_user:  swars_battle_user, swars_battle_grade: swars_battle_grade, judge_key: judge_key, location_key: Warabi::Location.fetch(i).key)
        end

        # SQLをシンプルにするために勝者だけ、所有者的な意味で、SwarsBattleRecord 自体に入れとく
        # いらんかったらあとでとる
        if winner_index
          swars_battle_record.win_swars_battle_user = swars_battle_record.swars_battle_ships[winner_index].swars_battle_user
        end

        begin
          swars_battle_record.save!
        rescue ActiveRecord::RecordNotUnique
        end
      end

      private

      def swars_battle_agent
        @swars_battle_agent ||= SwarsBattleAgent.new
      end
    end
  end
end
