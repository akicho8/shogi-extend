# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Battle (swars_battles as Swars::Battle)
#
# |-------------------+-------------------+-------------+-------------+------+-------|
# | name              | desc              | type        | opts        | refs | index |
# |-------------------+-------------------+-------------+-------------+------+-------|
# | id                | ID                | integer(8)  | NOT NULL PK |      |       |
# | key               | Key               | string(255) | NOT NULL    |      | A!    |
# | battled_at        | Battled at        | datetime    | NOT NULL    |      |       |
# | rule_key          | Rule key          | string(255) | NOT NULL    |      | B     |
# | csa_seq           | Csa seq           | text(65535) | NOT NULL    |      |       |
# | final_key         | Final key         | string(255) | NOT NULL    |      | C     |
# | win_user_id       | Win user          | integer(8)  |             |      | D     |
# | turn_max          | Turn max          | integer(4)  | NOT NULL    |      |       |
# | meta_info         | Meta info         | text(65535) | NOT NULL    |      |       |
# | last_accessd_at   | Last accessd at   | datetime    | NOT NULL    |      |       |
# | access_logs_count | Access logs count | integer(4)  | DEFAULT(0)  |      |       |
# | created_at        | 作成日時          | datetime    | NOT NULL    |      |       |
# | updated_at        | 更新日時          | datetime    | NOT NULL    |      |       |
# |-------------------+-------------------+-------------+-------------+------+-------|

require "matrix"

module Swars
  class Battle < ApplicationRecord
    include ConvertMethods

    belongs_to :win_user, class_name: "User", optional: true # 勝者プレイヤーへのショートカット。引き分けの場合は入っていない。memberships.win.user と同じ

    has_many :memberships, -> { order(:position) }, dependent: :destroy, inverse_of: :battle
    delegate :rival, :myself, to: :memberships

    has_many :access_logs, dependent: :destroy # アクセスログみたいもの

    has_many :users, through: :memberships do
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
      if rule_key
        self.rule_key = RuleInfo.fetch(rule_key).key
      end

      # キーは "(先手名)-(後手名)-(日付)" となっているので最後を開始日時とする
      if key
        self.battled_at ||= Time.zone.parse(key.split("-").last)
      end
    end

    with_options presence: true do
      validates :key
      validates :battled_at
      validates :rule_key
      validates :final_key
    end

    with_options allow_blank: true do
      validates :key, uniqueness: true
    end

    validate do
      if memberships.size != 2
        errors.add(:base, "対局者が2人いません : #{memberships.size}")
      end
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
          players = memberships.order(:position)
        else
          players = memberships
        end

        s = []
        s << ["N+", players.first.name_with_grade].join
        s << ["N-", players.second.name_with_grade].join
        s << ["$START_TIME", battled_at.to_s(:csa_ymdhms)] * ":"
        s << ["$EVENT", "将棋ウォーズ(#{rule_info.long_name})"] * ":"
        s << ["$TIME_LIMIT", rule_info.csa_time_limit] * ":"

        # $OPENING は 戦型 のことで、これが判明するのはパースの後なのでいまはわからない。
        # それに自動的にあとから埋められるのでここは指定しなくてよい
        # s << "$OPENING:不明"

        # 平手なので先手から
        s << "+"

        # 残り時間の並びから使用時間を求めつつ指し手と一緒に並べていく
        life = [rule_info.life_time] * memberships.size
        csa_seq.each.with_index do |(op, t), i|
          i = i.modulo(life.size)
          used = life[i] - t
          life[i] = t
          s << "#{op}"
          s << "T#{used}"
        end

        s << "%#{final_info.last_action_key}"
        s.join("\n") + "\n"
      end

      def parser_exec_after(info)
        # 囲い対決などに使う
        if true
          if persisted?
            ships = memberships.order(:position)
          else
            ships = memberships
          end
          info.mediator.players.each.with_index do |player, i|
            membership = ships[i]
            membership.defense_tag_list = player.skill_set.defense_infos.normalize.collect(&:key)
            membership.attack_tag_list  = player.skill_set.attack_infos.normalize.collect(&:key)
          end
        end

        other_tag_list << rule_info.name
        other_tag_list << final_info.name
      end
    end

    concerning :HelperMethods do
      def winner_desuka?(user)
        if win_user
          win_user == user
        end
      end

      def lose_desuka?(user)
        if win_user
          win_user != user
        end
      end

      def win_lose_str(user)
        if win_user
          if winner_desuka?(user)
            Fa.icon_tag(:far, :circle)
          else
            Fa.icon_tag(:fas, :times)
          end
        else
          Fa.icon_tag(:fas, :minus, :class => "icon_hidden")
        end
      end

      def wars_tweet_body
        vs = memberships.collect(&:name_with_grade).join(" 対 ")
        url = Rails.application.routes.url_helpers.swars_real_battle_url(self, tw: 1)
        "将棋ウォーズ棋譜(#{vs}) #{url} #shogiwars #将棋"
      end
    end

    concerning :ImportMethods do
      class_methods do
        def setup(options = {})
          super

          if Rails.env.development?
            basic_import(user_key: "hanairobiyori")
            reception_import
            expert_import
            conditional_import(grade_key_gteq: '三段')
            find_each do |e|
              e.parser_exec
              e.save!
            end
            p count
          end
        end

        def run(*args, **params, &block)
          import(*args, params, &block)
        end

        def old_record_destroy(**params)
          params = {
            time: 2.weeks.ago,
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
          counts = -> { Vector[User.count, Battle.count] }
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

        # Battle.reception_import(limit: 10, sleep: 5)
        def reception_import(**params)
          User.where.not(last_reception_at: nil).order(last_reception_at: :desc).limit(params[:limit] || 1).each do |user|
            basic_import(params.merge(user_key: user.user_key))
          end
        end

        # Battle.expert_import
        # Battle.expert_import(page_max: 3, sleep: 5)
        def expert_import(**params)
          agent.legend_user_keys.each do |user_key|
            basic_import(params.merge(user_key: user_key))
          end
        end

        # Battle.conditional_import(limit: 10, page_max: 3, sleep: 5, grade_key_gteq: "初段") # (10 * (3*10) * 5) / 60 = 25 min
        def conditional_import(**params)
          # 最近対局した初段以上のプレイヤー limit 人取得
          s = Membership.all
          # 初段以上の場合
          if true
            if v = params[:grade_key_gteq]
              priority = GradeInfo.fetch(v).priority
              s = s.joins(user: :grade).where(Grade.arel_table[:priority].lteq(priority))
            end
          end
          s = s.group(:user_id).select(:user_id)
          s = s.joins(:battle).order("max(#{Battle.table_name}.battled_at) desc")
          s = s.limit(params[:limit] || 1)
          # SELECT  `memberships`.`user_id` FROM `memberships` INNER JOIN `users` ON `users`.`id` = `memberships`.`user_id` INNER JOIN `grades` ON `grades`.`id` = `users`.`grade_id` INNER JOIN `battles` ON `battles`.`id` = `memberships`.`battle_id` WHERE (`grades`.`priority` <= 8) GROUP BY `memberships`.`user_id` ORDER BY max(battles.battled_at) desc LIMIT 1
          user_ids = s.pluck(:user_id)

          # 最近取り込んだプレイヤー limit 人取得
          # user_ids = Membership.group(:user_id).select(:user_id).order("max(created_at) desc").limit(params[:limit] || 1).pluck(:user_id)

          users = User.find(user_ids)

          users.each do |user|
            basic_import(params.merge(user_key: user.user_key))
          end
        end

        # Battle.basic_import(user_key: "DarkPonamin9")
        # Battle.basic_import(user_key: "micro77")
        # Battle.basic_import(user_key: "micro77", page_max: 3)
        def basic_import(**params)
          RuleInfo.each do |e|
            multiple_battle_import(params.merge(gtype: e.swars_real_key))
          end
        end

        # Battle.multiple_battle_import(user_key: "chrono_", gtype: "")
        def multiple_battle_import(**params)
          (params[:page_max] || 1).times do |i|
            list = agent.index_get(params.merge(page_index: i))

            # もうプレイしていない人のページは履歴が空なのでクロールを完全にやめる (もしくは過去のページに行きすぎたので中断)
            if list.empty?
              break
            end

            list.each do |history|
              key = history[:key]

              # すでに取り込んでいるならスキップ
              if Battle.where(key: key).exists?
                next
              end

              # # フィルタ機能
              # if true
              #   # 初段以上の指定がある場合
              #   if v = params[:grade_key_gteq]
              #     v = GradeInfo.fetch(v)
              #     # 取得してないときもあるため
              #     if user_infos = history[:user_infos]
              #       # 両方初段以上ならOK
              #       if user_infos.all? { |e| GradeInfo.fetch(e[:grade_key]).priority <= v.priority }
              #       else
              #         next
              #       end
              #     end
              #   end
              # end

              single_battle_import(key)
              sleep(params[:sleep].to_i)
            end
          end
        end

        def single_battle_import(key)
          # 登録済みなのでスキップ
          if Battle.where(key: key).exists?
            return
          end

          info = agent.record_get(key)

          # 対局中や引き分けのときは棋譜がないのでスキップ
          unless info[:st_done]
            return
          end

          # # 引き分けを考慮すると急激に煩雑になるため取り込まない
          # # ここで DRAW_SENNICHI も弾く
          # unless info[:__final_key].match?(/(SENTE|GOTE)_WIN/)
          #   return
          # end

          users = info[:user_infos].collect do |e|
            User.find_or_initialize_by(user_key: e[:user_key]).tap do |user|
              grade = Grade.find_by!(key: e[:grade_key])
              user.grade = grade # 常にランクを更新する
              begin
                user.save!
              rescue ActiveRecord::RecordNotUnique
              end
            end
          end

          battle = Battle.new({
              key: info[:key],
              rule_key: info.dig(:gamedata, :gtype),
              csa_seq: info[:csa_seq],
            })

          if md = info[:__final_key].match(/\A(?<prefix>\w+)_WIN_(?<final_key>\w+)/)
            winner_index = md[:prefix] == "SENTE" ? 0 : 1
            battle.final_key = md[:final_key]
          else
            winner_index = nil
            battle.final_key = info[:__final_key]
          end

          info[:user_infos].each.with_index do |e, i|
            user = User.find_by!(user_key: e[:user_key])
            grade = Grade.find_by!(key: e[:grade_key])

            if winner_index
              judge_key = (i == winner_index) ? :win : :lose
            else
              judge_key = :draw
            end

            battle.memberships.build(user:  user, grade: grade, judge_key: judge_key, location_key: Warabi::Location.fetch(i).key)
          end

          # SQLをシンプルにするために勝者だけ、所有者的な意味で、Battle 自体に入れとく
          # いらんかったらあとでとる
          if winner_index
            battle.win_user = battle.memberships[winner_index].user
          end

          begin
            battle.save!
          rescue ActiveRecord::RecordNotUnique
          end
        end

        private

        def agent
          @agent ||= Agent.new
        end
      end
    end
  end
end
