# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 対局テーブル (fanta_battles as Fanta::Battle)
#
# |---------------------+----------------------------------------------+-------------+---------------------+------+-------|
# | カラム名            | 意味                                         | タイプ      | 属性                | 参照 | INDEX |
# |---------------------+----------------------------------------------+-------------+---------------------+------+-------|
# | id                  | ID                                           | integer(8)  | NOT NULL PK         |      |       |
# | black_preset_key    | ▲手合割                                     | string(255) | NOT NULL            |      |       |
# | white_preset_key    | △手合割                                     | string(255) | NOT NULL            |      |       |
# | lifetime_key        | 時間                                         | string(255) | NOT NULL            |      |       |
# | platoon_key         | 人数                                         | string(255) | NOT NULL            |      |       |
# | full_sfen           | USI形式棋譜                                  | text(65535) | NOT NULL            |      |       |
# | clock_counts        | 対局時計情報                                 | text(65535) | NOT NULL            |      |       |
# | countdown_flags     | 秒読み状態                                   | text(65535) | NOT NULL            |      |       |
# | turn_max            | 手番数                                       | integer(4)  | NOT NULL            |      |       |
# | battle_request_at   | 対局申し込みによる成立日時                   | datetime    |                     |      |       |
# | auto_matched_at     | 自動マッチングによる成立日時                 | datetime    |                     |      |       |
# | begin_at            | メンバーたち部屋に入って対局開始になった日時 | datetime    |                     |      |       |
# | end_at              | バトル終了日時                               | datetime    |                     |      |       |
# | last_action_key     | 最後の状態                                   | string(255) |                     |      |       |
# | win_location_key    | 勝った方の先後                               | string(255) |                     |      |       |
# | current_users_count | この部屋にいる人数                           | integer(4)  | DEFAULT(0) NOT NULL |      |       |
# | watch_ships_count   | この部屋の観戦者数                           | integer(4)  | DEFAULT(0) NOT NULL |      |       |
# | created_at          | 作成日時                                     | datetime    | NOT NULL            |      |       |
# | updated_at          | 更新日時                                     | datetime    | NOT NULL            |      |       |
# |---------------------+----------------------------------------------+-------------+---------------------+------+-------|

module Fanta
  class Battle < ApplicationRecord
    class << self
      def setup(options = {})
        super

        if Rails.env.development?
          users = User.all
          50.times do
            list = users.sample(4)
            battle = create!
            list.each do |e|
              battle.users << e
            end
            if rand(2).zero?
              battle.update!(begin_at: Time.current)
              if rand(2).zero?
                battle.update!(end_at: Time.current)
              end
            end
          end

          p count
        end
      end
    end

    scope :latest_list, -> { order(updated_at: :desc).limit(50) }
    scope :latest_list_for_profile, -> { order(updated_at: :desc).limit(25) }
    scope :st_battle_now, -> { where.not(begin_at: nil).where(end_at: nil) }

    serialize :clock_counts
    serialize :countdown_flags

    before_validation on: :create do
      self.black_preset_key ||= "平手"
      self.white_preset_key ||= "平手"
      self.lifetime_key ||= :lifetime_m5
      self.platoon_key ||= :platoon_p1vs1
      self.turn_max ||= 0
      self.clock_counts ||= {black: [], white: []}
      self.countdown_flags ||= {black: false, white: false}
    end

    before_validation do
      if changes_to_save[:black_preset_key] || changes_to_save[:white_preset_key]
        if black_preset_key && white_preset_key
          mediator = Warabi::Mediator.new
          mediator.board.placement_from_hash(black: black_preset_key, white: white_preset_key)
          mediator.turn_info.handicap = handicap
          self.full_sfen = "position #{mediator.to_long_sfen}"
        end
      end
    end

    def name
      # if users.present?
      #   users.collect(&:name).join(" vs ")
      # else
      #   names = []
      #   if room_owner
      #     names << "#{room_owner.name}の"
      #   end
      #   names << "対戦部屋 ##{Battle.count.next}"
      #   names.join
      # end
      "##{id}"
    end

    def xstate_key
      if begin_at && end_at
        :st_done
      elsif begin_at
        :st_battle_now
      else
        :st_before
      end
    end

    def xstate_info
      XstateInfo.fetch(xstate_key)
    end

    def human_kifu_text
      info = Warabi::Parser.parse(full_sfen, typical_error_case: :embed)
      begin
        mediator = info.mediator
      rescue => error
        return error.message
      end
      if begin_at
        info.header["開始日時"] = begin_at.to_s(:csa_ymdhms)
      end
      if end_at
        info.header["終了日時"] = end_at.to_s(:csa_ymdhms)
      end
      if persisted?
        info.header["場所"] = Rails.application.routes.url_helpers.url_for([self, {only_path: false}.merge(ActionMailer::Base.default_url_options)])
      end
      info.names_set(names_hash)
      info.to_ki2
    end

    def show_path
      Rails.application.routes.url_helpers.url_for([self, only_path: true])
    end

    def handicap
      !(black_preset_key == "平手" && white_preset_key == "平手")
    end

    def names_hash
      memberships.group_by(&:location_key).transform_values { |a| a.collect { |e| e.user.name }.join("・") }.symbolize_keys
    end

    concerning :LobbyMethods do
      included do
        after_create_commit  { cud_broadcast(:create)  }
        after_update_commit  { cud_broadcast(:update)  }
        after_destroy_commit { cud_broadcast(:destroy) }
      end

      def cud_broadcast(action)
        ActionCable.server.broadcast("lobby_channel", battle_cud: {action: action, battle: ams_sr(self, serializer: BattleEachSerializer)})
      end
    end

    concerning :BattleMethods do
      def battle_start
        update!(begin_at: Time.current)
        # 開始日時が埋められた棋譜で更新したいため
        ActionCable.server.broadcast(channel_key, {begin_at: begin_at, human_kifu_text: human_kifu_text})
      end

      # 部屋が抜けたときの状態も簡単に反映できるように全メンバー一気に送るのでよさそう
      def memberships_broadcast
        ActionCable.server.broadcast(channel_key, memberships: ams_sr(reload.memberships)) # 部屋を抜けたときの状態が反映されるように reload が必要
      end

      def channel_key
        "battle_channel_#{id}"
      end

      class Brain
        attr_reader :battle, :mediator

        delegate :current_user, to: :battle
        delegate :cpu_brain_info, to: :current_user

        def initialize(battle, mediator)
          @battle = battle
          @mediator = mediator
        end

        # 現局面で王手放置していたら指した人の負け
        #
        # - 王手放置は合法な手としてすにで指している
        # - そのため王手放置で負けるのは前に指した opponent_player
        # - 逆に勝つのは current_player
        # - 指した直後にもかかわらず王手の状態になっている -> 王手放置 or 自らピンを外した(自滅)
        #
        def validate_checkmate_ignore
          if mediator.opponent_player.mate_danger?
            User.sysop.chat_say(battle, "【反則】#{mediator.to_ki2_a.last}としましたが王手放置または自滅です", msg_class: "has-text-danger")
            battle.game_end_exit(win_location_key: mediator.current_player.location.key, last_action_key: "ILLEGAL_MOVE")
          end
        end

        # 次の手番の合法手がない = 詰ました = 勝ち
        def win_check
          if mediator.current_player.legal_all_hands.none?
            # if mediator.current_player.normal_all_hands.none? { |e| e.legal_move?(mediator) }
            User.sysop.chat_say(battle, "【詰み】#{mediator.current_player.call_name}はもう指す手がありません", msg_class: "has-text-danger")
            battle.game_end_exit(win_location_key: mediator.opponent_player.location.key, last_action_key: "TSUMI")
          end
        end

        def execute_loop_if_robot
          loop do
            if !current_user.race_info.auto_hand
              break
            end
            execute_one
          end
        end

        def execute_one
          clock_counter = measure_time do

            # captured_soldier = mediator.opponent_player.executor.captured_soldier
            # if captured_soldier
            #   if captured_soldier.piece.key == :king
            #     render json: {you_win_message: "玉を取って勝ちました！", sfen: mediator.to_sfen}
            #     return
            #   end
            # end

            hand = nil
            puts mediator

            # 先を読む
            if cpu_brain_info.depth_max_range
              brain = mediator.current_player.brain(diver_class: Warabi::NegaScoutDiver, evaluator_class: Warabi::EvaluatorAdvance)
              records = []

              cpu_brain_info.time_limit.each.with_index(1) do |tl, i|
                begin
                  tp({i: "#{i}回目", time_limit: tl})
                  __trace("#{cpu_brain_info.depth_max_range}手先まで最大#{tl}秒かけて読んでます")
                  records = brain.iterative_deepening(time_limit: tl, depth_max_range: cpu_brain_info.depth_max_range)
                  break
                rescue Warabi::BrainProcessingHeavy
                  __trace("無理でした")
                end
              end

              unless records.empty?
                tp Warabi::Brain.human_format(records)

                record = records.first
                tp record.keys
                hand = record[:hand]

                __trace("#{record[:best_pv].size}手先まで読んで#{hand}を指しました。評価値:#{record[:score2]} 読み筋:#{record[:best_pv].collect(&:to_s).join(' ')}")
              end
            end

            # 読めなかった場合はランダムまたは合法手から選択する
            unless hand
              hands = mediator.current_player.normal_all_hands.to_a
              legal = cpu_brain_info.legal_only
              if cpu_brain_info.mate_danger_check
                legal ||= mediator.current_player.mate_danger?
              end
              if legal
                hands = hands.find_all { |e| e.legal_move?(mediator) }
              end
              hand = hands.sample

              if hand
                if legal
                  __trace("合法手から#{hand}")
                else
                  __trace("ランダムで#{hand}")
                end
              end
            end

            # 手がなければ詰まされている
            unless hand
              battle.game_end_exit(win_location_key: mediator.opponent_player.location.key, last_action_key: "TSUMI")
            end

            mediator.execute(hand.to_sfen, executor_class: Warabi::PlayerExecutorCpu)
            validate_checkmate_ignore
          end

          clock_counts_update(clock_counter)
          mediator_broadcast
          win_check
        end

        def measure_time
          Time.current.yield_self do |t|
            yield
            (Time.current - t).ceil
          end
        end

        def clock_counts_update(clock_counter)
          battle.clock_counts[mediator.opponent_player.location.key].push(clock_counter) # push でも AR は INSERT 対象になる
          battle.save!
        end

        def mediator_broadcast
          battle.full_sfen = mediator.to_sfen
          battle.turn_max = mediator.turn_info.turn_max
          battle.save!

          broadcast_hash = {
            :turn_max        => mediator.turn_info.turn_max,
            :last_hand       => mediator.to_ki2_a.last, # FIXME: 使ってない？
            :full_sfen       => battle.full_sfen,
            :human_kifu_text => battle.human_kifu_text,
            :clock_counts    => battle.clock_counts,
          }

          ActionCable.server.broadcast(battle.channel_key, broadcast_hash)
        end

        def __trace(message)
          return if Rails.env.production?
          current_user.chat_say(battle, message, msg_class: "has-text-danger")
        end
      end

      def next_run_if_robot
        catch :exit do
          brain_get(full_sfen).tap do |o|
            o.execute_loop_if_robot
          end
        end
      end

      def next_run
        catch :exit do
          brain_get(full_sfen).tap do |o|
            o.execute_one
            o.execute_loop_if_robot
          end
        end
      end

      # 人間が指した直後のトリガー
      def play_mode_long_sfen_set(data)
        catch :exit do
          brain_get(data["kifu_body"]).tap do |o|
            o.validate_checkmate_ignore

            o.clock_counts_update(data["clock_counter"].to_i)
            o.mediator_broadcast
            o.win_check

            o.execute_loop_if_robot
          end
        end
      end

      def brain_get(kifu_body)
        begin
          Brain.new(self, Warabi::Parser.parse(kifu_body).mediator)
        rescue Warabi::WarabiError => error
          if !error.respond_to?(:mediator)
            raise "must not happen: #{error}"
          end
          User.sysop.chat_say(self, error.message.lines.first.strip, msg_class: "has-text-danger")
          game_end_exit(win_location_key: error.mediator.win_player.location.key, last_action_key: "ILLEGAL_MOVE")
        end
      end

      def game_end(attributes)
        update!(attributes.merge(end_at: Time.current))
        game_end_broadcast
      end

      def game_end_exit(attributes)
        game_end(attributes)
        throw :exit
      end

      def game_end_broadcast
        robots  = users.find_all { |e| e.race_info.key == :robot }.uniq
        robots.each do |e|
          e.chat_say(self, "負けました(T_T) ありがとうございました〜")
          e.room_out(self)
        end

        ActionCable.server.broadcast(channel_key, {
            end_at: end_at,
            win_location_key: win_location_key,
            last_action_key: last_action_key,
            human_kifu_text: human_kifu_text, # end_at が埋めこまれた棋譜で更新しておくため
          })
      end

      def time_up(data)
        if false
          # membership_ids は送ってきた人で対応するレコードにタイムアップ認定する
          memberships = self.memberships.where(id: data["membership_ids"])
          memberships.each do |e|
            e.update!(time_up_at: Time.current)
          end

          # メンバー全員がタイムアップ認定したら全員にタイムアップ通知する
          # こうすることで1秒残してタイムアップにならなくなる
          if memberships.where.not(time_up_at: nil).count >= self.memberships.count
            game_end(win_location_key: data["win_location_key"], last_action_key: "TIME_UP")
          end
        else
          game_end(win_location_key: data["win_location_key"], last_action_key: "TIME_UP")
        end
      end

      def give_up(data)
        game_end(win_location_key: data["win_location_key"], last_action_key: "TORYO")
      end

      def countdown_flag_on(data)
        location = Warabi::Location.fetch(data["location_key"])
        countdown_flags[location.key] = true
        save!
      end
    end

    # 対局者
    concerning :UserMethods do
      included do
        has_many :memberships, dependent: :destroy
        has_many :users, through: :memberships
      end

      def user_by_turn(turn)
        position = turn.modulo(memberships.size)
        memberships.find_by(position: position).user
      end

      def current_user
        user_by_turn(turn_max)
      end

      def robot_player?
        current_user.race_info.key == :robot
      end
    end

    # 観戦者
    concerning :WatchUserMethods do
      included do
        has_many :watch_ships, dependent: :destroy                        # 観戦中の人たち(中間情報)
        has_many :watch_users, through: :watch_ships, source: :user # 観戦中の人たち
      end
    end

    # チャット関連
    concerning :ChatMessageMethods do
      included do
        cattr_accessor(:chat_window_size) { 10 }

        has_many :chat_messages, dependent: :destroy do
          def limited_latest_list
            latest_list.limit(chat_window_size)
          end
        end
      end

      def chat_say(user, message, **msg_options)
        user.chat_say(battle, message, msg_options)
      end
    end
  end
end
