# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 将棋ウォーズ対戦情報 (swars_battles as Swars::Battle)
#
# |-------------------+------------------+-------------+-------------+------+-------|
# | name              | desc             | type        | opts        | refs | index |
# |-------------------+------------------+-------------+-------------+------+-------|
# | id                | ID               | integer(8)  | NOT NULL PK |      |       |
# | key               | 対局ユニークキー | string(255) | NOT NULL    |      | A!    |
# | battled_at        | 対局日時         | datetime    | NOT NULL    |      | E     |
# | rule_key          | ルール           | string(255) | NOT NULL    |      | B     |
# | csa_seq           | 棋譜             | text(65535) | NOT NULL    |      |       |
# | final_key         | 結末             | string(255) | NOT NULL    |      | C     |
# | win_user_id       | 勝者             | integer(8)  |             |      | D     |
# | turn_max          | 手数             | integer(4)  | NOT NULL    |      | F     |
# | meta_info         | メタ情報         | text(65535) | NOT NULL    |      |       |
# | last_accessd_at   | 最終アクセス日時 | datetime    | NOT NULL    |      |       |
# | access_logs_count | アクセス数       | integer(4)  | DEFAULT(0)  |      |       |
# | created_at        | 作成日時         | datetime    | NOT NULL    |      |       |
# | updated_at        | 更新日時         | datetime    | NOT NULL    |      |       |
# | preset_key        | 手合割           | string(255) | NOT NULL    |      |       |
# | start_turn        | 開始手数         | integer(4)  | NOT NULL    |      |       |
# |-------------------+------------------+-------------+-------------+------+-------|

require "matrix"

module Swars
  class Battle < ApplicationRecord
    include BattleModelSharedMethods

    belongs_to :win_user, class_name: "User", optional: true # 勝者プレイヤーへのショートカット。引き分けの場合は入っていない。memberships.win.user と同じ

    has_many :memberships, -> { order(:position) }, dependent: :destroy, inverse_of: :battle
    delegate :rival, :myself, to: :memberships # FIXME: 使用禁止

    has_many :access_logs, dependent: :destroy # アクセスログみたいもの

    has_many :users, through: :memberships do
      # 先手/後手プレイヤー
      def black                 # FIXME: 使用禁止
        first
      end

      def white
        second
      end
    end

    before_validation on: :create do
      # "" から ten_min への変換
      if rule_key
        self.rule_key = RuleInfo.fetch(rule_key).key
      end

      # キーは "(先手名)-(後手名)-(日付)" となっているので最後を開始日時とする
      if key
        self.battled_at ||= Time.zone.parse(key.split("-").last)
      end

      self.last_accessd_at ||= Time.current

      if Rails.env.development? || Rails.env.test?
        self.key ||= SecureRandom.hex
        self.battled_at ||= Time.current
        self.rule_key ||= :ten_min
        self.final_key ||= :TORYO
        self.preset_key ||= :"平手"
      end
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

    concerning :ConvertHookMethos do
      included do
        serialize :csa_seq

        before_validation do
        end

        before_save do
          if changes_to_save[:csa_seq] && csa_seq
            parser_exec
          end
        end
      end

      def kifu_body
        type = [rule_info.long_name]
        if memberships.any? { |e| e.grade.grade_info.key == :"十段" }
          type << "指導対局"
        end
        if preset_info.handicap
          type << preset_info.name
        end

        s = []
        s << ["N+", memberships.first.name_with_grade].join
        s << ["N-", memberships.second.name_with_grade].join
        s << ["$START_TIME", battled_at.to_s(:csa_ymdhms)] * ":"
        s << ["$EVENT", "将棋ウォーズ(#{type.join(' ')})"] * ":"
        s << ["$SITE", wars_url] * ":"
        s << ["$TIME_LIMIT", rule_info.csa_time_limit] * ":"

        # $OPENING は 戦型 のことで、これが判明するのはパースの後なのでいまはわからない。
        # それに自動的にあとから埋められるのでここは指定しなくてよい
        # s << "$OPENING:不明"

        if preset_info.handicap
          s << preset_info.to_board.to_csa.strip
          s << "-"
        else
          s << "+"
        end

        # 残り時間の並びから使用時間を求めつつ指し手と一緒に並べていく
        life = [rule_info.life_time] * memberships.size
        csa_seq.each.with_index do |(op, t), i|
          i = i.modulo(life.size)
          used = life[i] - t
          life[i] = t
          s << "#{op}"
          s << "T#{used}" # 将棋ウォーズの不具合で時間がマイナスになることがある
        end

        s << "%#{final_info.last_action_key}"
        s.join("\n") + "\n"
      end

      def fast_parsed_options
        {
          validate_skip: true,
          candidate_skip: true,
        }
      end

      def parser_exec_after(info)
        # 囲い対決などに使う
        if true
          info.mediator.players.each.with_index do |player, i|
            memberships[i].tap do |e|
              e.defense_tag_list   = player.skill_set.defense_infos.normalize.collect(&:key)
              e.attack_tag_list    = player.skill_set.attack_infos.normalize.collect(&:key)
              e.technique_tag_list = player.skill_set.technique_infos.normalize.collect(&:key)
              e.note_tag_list      = player.skill_set.note_infos.normalize.collect(&:key)
            end
          end

          # if memberships.all? { |e| e.note_tag_list.include?("入玉") }
          #   memberships.each do |e|
          #     e.note_tag_list.add "相入玉"
          #   end
          #   note_tag_list.add "相入玉"
          # end
        end

        memberships.each do |e|
          if e.grade.grade_info.key == :"十段"
            e.note_tag_list.add "指導対局"
            note_tag_list.add "指導対局"
          end
        end

        other_tag_list.add preset_info.name
        if preset_info.handicap
          other_tag_list.add "駒落ち"
        end

        other_tag_list.add rule_info.name
        other_tag_list.add final_info.name
      end
    end

    concerning :HelperMethods do
      class_methods do
        def extraction_key_from_dirty_string(str)
          # コピペで空白を入れる人がいるため strip でもいいがいっそのことURLだけを抽出する
          if url = URI.extract(str, ["http", "https"]).first
            if url.include?("kif-pona.heroz.jp/games") # FIXME
              URI(url).path.split("/").last
            end
          end
        end
      end

      def wars_tweet_body
        "将棋ウォーズ棋譜(#{to_title}) #{wars_url} #shogiwars #将棋"
      end

      def wars_url
        Rails.application.routes.url_helpers.swars_real_battle_url(self)
      end

      def header_detail(h)
        super.merge("場所" => h.link_to(key, wars_url, target: "_blank"))
      end

      def to_title
        memberships.collect(&:name_with_grade).join(" 対 ")
      end

      def description
        out = []
        out << "将棋ウォーズ#{rule_info.long_name}"
        # out << final_info.name
        out << memberships.collect { |e| (e.attack_tag_list.presence || ["その他"]).join(" ") }.join(" vs ")
        out.join(" ")
      end
    end

    concerning :ImportMethods do
      included do
      end

      class_methods do
        def setup(options = {})
          super

          if Rails.env.development?
            user_import(user_key: "devuser1")
            User.find_each { |e| e.search_logs.create! }
            puts Crawler::RegularCrawler.new.run.rows.to_t
            puts Crawler::ExpertCrawler.new.run.rows.to_t
            find_each(&:remake)
            p count
          end
        end

        def run(*args, **params, &block)
          import(*args, params, &block)
        end

        def old_record_destroy(**params)
          params = {
            time: 1.months.ago,
          }.merge(params)

          all.where(arel_table[:last_accessd_at].lteq(params[:time])).destroy_all
        end

        # cap production rails:runner CODE='Swars::Battle.import(:remake)'
        def remake(**params)
          params = {
            limit: 256,
          }.merge(params)

          c = Hash.new(0)
          all.order(last_accessd_at: :desc).limit(params[:limit]).each do |e|
            c[e.remake] += 1
          end
          puts
          p c
        end

        def sometimes_user_import(**params)
          # キャッシュの有効時間のみ利用して連続実行を防ぐ
          if true
            seconds = Rails.env.production? ? 3.minutes : 0.seconds
            cache_key = ["sometimes_user_import", params[:user_key], params[:page_max]].join("/")
            if Rails.cache.exist?(cache_key)
              return false
            end
            Rails.cache.write(cache_key, true, expires_in: seconds)
          end

          user_import(params)
          true
        end

        # Battle.user_import(user_key: "DarkPonamin9")
        # Battle.user_import(user_key: "micro77")
        # Battle.user_import(user_key: "micro77", page_max: 3)
        def user_import(**params)
          RuleInfo.each do |e|
            multiple_battle_import(params.merge(gtype: e.swars_real_key))
          end
        end

        # Battle.multiple_battle_import(user_key: "chrono_", gtype: "")
        def multiple_battle_import(**params)
          params = {
            verbose: Rails.env.development?,
            early_break: false, # 1ページ目で新しいものが見つからなければ終わる
          }.merge(params)

          keys = []
          (params[:page_max] || 1).times do |i|
            list = []
            unless params[:dry_run]
              list = Agent.new(params).index_get(params.merge(page_index: i))
            end
            sleep_on(params)

            page_keys = list.collect { |e| e[:key] }
            keys += page_keys

            # アクセス数を減らすために10件未満なら終了する
            if page_keys.size < Agent.items_per_page
              if params[:verbose]
                tp "#{page_keys.size} < #{Agent.items_per_page}"
              end
              break
            end

            if params[:early_break]
              # 1ページ目で新しいものがなければ終わる
              new_keys = page_keys - where(key: page_keys).pluck(:key)
              if params[:verbose]
                tp "#{i}ページの新しいレコード数: #{new_keys.size}"
              end
              if new_keys.empty?
                break
              end
            end

            # if Battle.where(key: key).exists?

            # list.each do |history|
            #   key = history[:key]
            #
            #   # すでに取り込んでいるならスキップ
            #   if Battle.where(key: key).exists?
            #     next
            #   end

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
          end

          new_keys = keys - where(key: keys).pluck(:key)
          new_keys.each do |key|
            single_battle_import(params.merge(key: key, validate_skip: true))
            sleep_on(params)
          end
        end

        def single_battle_import(**params)
          params = {
            verbose: Rails.env.development?,
          }.merge(params)

          # 登録済みなのでスキップ
          unless params[:validate_skip]
            if Battle.where(key: params[:key]).exists?
              return
            end
          end

          info = Agent.new(params).record_get(params[:key])

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

          # 将棋ウォーズのコードがマジックナンバーなため見当つけて変換する
          preset_info = DirtyPresetInfo.fetch("__handicap_embed__#{info[:preset_dirty_code]}").real_preset_info

          battle = Battle.new({
              key: info[:key],
              rule_key: info.dig(:gamedata, :gtype),
              csa_seq: info[:csa_seq],
              preset_key: preset_info.key,
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

            battle.memberships.build(user:  user, grade: grade, judge_key: judge_key, location_key: Bioshogi::Location.fetch(i).key)
          end

          # SQLをシンプルにするために勝者だけ、所有者的な意味で、Battle 自体に入れとく
          # いらんかったらあとでとる
          # if winner_index
          #   battle.win_user = battle.memberships[winner_index].user
          # end

          begin
            battle.save!
          rescue ActiveRecord::RecordNotUnique
          end
        end

        private

        def sleep_on(params)
          if params[:dry_run]
            return
          end

          if v = params[:sleep]
            v = v.to_f
            if v.positive?
              if params[:verbose]
                tp "sleep: #{v}"
              end
              sleep(v)
            end
          end
        end
      end
    end
  end
end
