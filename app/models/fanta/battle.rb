# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 対局テーブル (fanta_battles as Fanta::Battle)
#
# |---------------------+---------------------+-------------+---------------------+------+-------|
# | カラム名            | 意味                | タイプ      | 属性                | 参照 | INDEX |
# |---------------------+---------------------+-------------+---------------------+------+-------|
# | id                  | ID                  | integer(8)  | NOT NULL PK         |      |       |
# | black_preset_key    | Black preset key    | string(255) | NOT NULL            |      |       |
# | white_preset_key    | White preset key    | string(255) | NOT NULL            |      |       |
# | lifetime_key        | Lifetime key        | string(255) | NOT NULL            |      |       |
# | platoon_key         | Platoon key         | string(255) | NOT NULL            |      |       |
# | full_sfen      | Kifu body sfen      | text(65535) | NOT NULL            |      |       |
# | clock_counts        | Clock counts        | text(65535) | NOT NULL            |      |       |
# | countdown_mode_hash | Countdown mode hash | text(65535) | NOT NULL            |      |       |
# | turn_max            | Turn max            | integer(4)  | NOT NULL            |      |       |
# | battle_request_at   | Battle request at   | datetime    |                     |      |       |
# | auto_matched_at     | Auto matched at     | datetime    |                     |      |       |
# | begin_at            | Begin at            | datetime    |                     |      |       |
# | end_at              | End at              | datetime    |                     |      |       |
# | last_action_key     | Last action key     | string(255) |                     |      |       |
# | win_location_key    | Win location key    | string(255) |                     |      |       |
# | current_users_count | Current users count | integer(4)  | DEFAULT(0) NOT NULL |      |       |
# | watch_ships_count   | Watch ships count   | integer(4)  | DEFAULT(0) NOT NULL |      |       |
# | created_at          | 作成日時            | datetime    | NOT NULL            |      |       |
# | updated_at          | 更新日時            | datetime    | NOT NULL            |      |       |
# |---------------------+---------------------+-------------+---------------------+------+-------|

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

    has_many :current_users, class_name: "User", foreign_key: :current_battle_id, dependent: :nullify

    scope :latest_list, -> { order(updated_at: :desc).limit(50) }
    scope :latest_list_for_profile, -> { order(updated_at: :desc).limit(25) }
    scope :st_battling, -> { where.not(begin_at: nil).where(end_at: nil) }

    serialize :clock_counts
    serialize :countdown_mode_hash

    before_validation on: :create do
      self.black_preset_key ||= "平手"
      self.white_preset_key ||= "平手"
      self.lifetime_key ||= :lifetime_m5
      self.platoon_key ||= :platoon_p1vs1
      self.turn_max ||= 0
      self.clock_counts ||= {black: [], white: []}
      self.countdown_mode_hash ||= {black: false, white: false}
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
        :st_battling
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

    # after_commit do
    #   broadcast
    # end

    # def broadcast
    #   # ActionCable.server.broadcast("lobby_channel", battles: JSON.load(self.class.latest_list.to_json(to_json_params)))
    #   # ActionCable.server.broadcast("battle_channel_#{id}", battle: js_attributes) # FIXME: これは重いだけで使ってないのではずす
    # end

    # def js_attributes
    #   JSON.load(to_json(to_json_params))
    # end

    def show_path
      Rails.application.routes.url_helpers.url_for([self, only_path: true])
    end

    def handicap
      !(black_preset_key == "平手" && white_preset_key == "平手")
    end

    def names_hash
      memberships.group_by(&:location_key).transform_values { |a| a.collect { |e| e.user.name }.join("・") }.symbolize_keys
    end

    concerning :BattleMethods do
      def battle_start
        update!(begin_at: Time.current)
        # 開始日時が埋められた棋譜で更新したいため
        ActionCable.server.broadcast(channel_key, {begin_at: begin_at, human_kifu_text: human_kifu_text})
      end

      # 部屋が抜けたときの状態も簡単に反映できるように全メンバー一気に送るのでよさそう
      def memberships_update
        ActionCable.server.broadcast(channel_key, memberships: ams_sr(reload.memberships)) # 部屋を抜けたときの状態が反映されるように reload が必要
      end

      def channel_key
        "battle_channel_#{id}"
      end

      def saisyonisasu
        catch :game_end do
          mediator = mediator_get_by_kifu_body(full_sfen)
          p ["#{__FILE__}:#{__LINE__}", __method__, full_sfen, mediator.turn_info.turn_max]
          oute_houti_check(mediator)
          tsumashita_check(mediator)
          catch :loop_break do
            loop do
              sasimasu(mediator)
            end
          end
          p ["#{__FILE__}:#{__LINE__}", __method__, full_sfen]
        end
      end

      # 人間が指した直後のトリガー
      def play_mode_long_sfen_set(data)
        catch :game_end do
          mediator = mediator_get_by_kifu_body(data["kifu_body"])
          oute_houti_check(mediator)
          # ここからは棋譜として正しい
          # とりあえず人間が指した盤面をみんなと共有する
          mediator_broadcast(mediator, clock_counter: data["clock_counter"].to_i)
          tsumashita_check(mediator)
          catch :loop_break do
            loop do
              sasimasu(mediator)
            end
          end
        end
      end

      def mediator_get_by_kifu_body(kifu_body)
        # current_location = Warabi::Location.fetch(data["current_location_key"])
        info = Warabi::Parser.parse(kifu_body)
        mediator = nil
        begin
          mediator = info.mediator
        rescue Warabi::WarabiError => error
          if !error.respond_to?(:mediator)
            raise "must not happen: #{error}"
          end
          chat_say("message" => "<span class=\"has-text-info\">#{error.message.lines.first.strip}</span>")
          game_end2(win_location_key: error.mediator.win_player.location.key, last_action_key: "ILLEGAL_MOVE")
        end
        mediator
      end

      def oute_houti_check(mediator)
        # opponent_player: 今指した人
        # current_player:  次に指す人
        # 指した直後にもかかわらず王手の状態になっている -> 王手放置 or 自らピンを外した(自滅)
        if mediator.opponent_player.mate_danger?
          chat_say("message" => "<span class=\"has-text-info\">【反則】#{mediator.to_ki2_a.last}としましたが王手放置または自滅です</span>")
          game_end2(win_location_key: mediator.current_player.location.key, last_action_key: "ILLEGAL_MOVE")
        end
      end

      def tsumashita_check(mediator)
        # 次に指す人の合法手がない場合 = 詰ました
        hands = mediator.current_player.normal_all_hands.find_all { |e| e.legal_move?(mediator) }
        if hands.empty?
          game_end2(win_location_key: mediator.opponent_player.location.key, last_action_key: "TSUMI")
        end
      end

      def sasimasu(mediator)
        user = user_by_turn(mediator.turn_info.turn_max)

        # 次に指す人が人間なら終わる
        if !user.behavior_info.auto_sasu
          throw :loop_break
        end

        time_start = Time.current

        # 次に指すのはコンピュータ
        hands = mediator.current_player.normal_all_hands.to_a
        # if current_cpu_brain_info.legal_only
        if true
          hands = hands.find_all { |e| e.legal_move?(mediator) }
        end
        hand = hands.sample
        unless hand
          game_end2(win_location_key: mediator.opponent_player.location.key, last_action_key: "TSUMI")
        end

        # CPUの手を指す
        mediator.execute(hand.to_sfen, executor_class: Warabi::PlayerExecutorCpu)
        p ["#{__FILE__}:#{__LINE__}", __method__, hand]

        oute_houti_check(mediator)

        clock_counter = (Time.current - time_start).ceil
        mediator_broadcast(mediator, clock_counter: clock_counter)

        tsumashita_check(mediator)
      end

      def mediator_broadcast(mediator, clock_counter: 0)
        self.full_sfen = mediator.to_sfen
        self.clock_counts[mediator.opponent_player.location.key].push(clock_counter) # push でも AR は INSERT 対象になる
        self.turn_max = mediator.turn_info.turn_max
        save!

        broadcast_hash = {
          :turn_max        => mediator.turn_info.turn_max,
          :last_hand       => mediator.to_ki2_a.last, # FIXME: 使ってない？
          :full_sfen       => full_sfen,
          :human_kifu_text => human_kifu_text,
          :clock_counts    => clock_counts,
        }

        ActionCable.server.broadcast(channel_key, broadcast_hash)
      end

      def game_end(attributes)
        update!(attributes.merge(end_at: Time.current))
        game_end_broadcast
      end

      def game_end2(attributes)
        game_end(attributes)
        throw :game_end
      end

      def game_end_broadcast
        ActionCable.server.broadcast(channel_key, {
            end_at: end_at,
            win_location_key: win_location_key,
            last_action_key: last_action_key,
            human_kifu_text: human_kifu_text, # end_at が埋めこまれた棋譜で更新しておくため
          })
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
        membership = memberships.where(position: position).take
        membership.user
      end

      def active_user
        user_by_turn(turn_max)
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
    end
  end
end
