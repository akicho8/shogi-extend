module Colosseum::Battle::BattleMethods
  extend ActiveSupport::Concern

  class_methods do
    # cap production rails:runner CODE='Colosseum::Battle.auto_close'
    def auto_close(**options)
      options = {
        time: nil,
      }.merge(options)

      kesuyatu(options).each do |e|
        SlackAgent.message_send(key: "自動終了", body: e.long_name)
        if e.xstate_key == :st_before
          # まったく始まってないのは削除
          e.destroy!
        else
          # 始まったけど終ってないものは強制終了
          e.game_end({})
        end
      end
    end
  end

  included do
    scope :kesuyatu, -> **options { where(begin_at: nil).or(where(end_at: nil)).where(arel_table[:created_at].lteq(((options[:time] || 2.hour)).seconds.ago)).order(:created_at) }
  end

  def battle_start
    unless begin_at
      update!(begin_at: Time.current)
      # human_kifu_text まで入れているのは開始日時が埋められた最新の状態にしたいため
      ActionCable.server.broadcast(channel_key, {begin_at: begin_at, human_kifu_text: human_kifu_text})
    end
  end

  def channel_key
    "battle_channel_#{id}"
  end

  class Brain
    attr_reader :battle, :mediator

    delegate :active_user, to: :battle
    delegate :cpu_brain_info, to: :active_user

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
        # if mediator.current_player.create_all_hands.none? { |e| e.legal_hand?(mediator) }
        User.sysop.chat_say(battle, "【詰み】#{mediator.current_player.call_name}はもう指す手がありません", msg_class: "has-text-danger")
        battle.game_end_exit(win_location_key: mediator.opponent_player.location.key, last_action_key: "TSUMI")
      end
    end

    def execute_loop_if_robot
      loop do
        if !active_user.race_info.auto_hand
          break
        end
        execute_one
      end
    end

    def execute_one
      clock_counter = measure_time do
        hand = nil

        unless Rails.env.production?
          if ENV["VERBOSE"]
            puts mediator
          end
        end

        # 先を読む
        if cpu_brain_info.depth_max_range
          brain = mediator.current_player.brain(diver_class: Bioshogi::Diver::NegaScoutDiver, evaluator_class: Bioshogi::EvaluatorAdvance)
          records = []

          cpu_brain_info.time_limit.each.with_index(1) do |tl, i|
            begin
              tp({i: "#{i}回目", time_limit: tl})
              __trace("#{cpu_brain_info.depth_max_range}手先まで最大#{tl}秒かけて読んでます")
              records = brain.iterative_deepening(time_limit: tl, depth_max_range: cpu_brain_info.depth_max_range)
              break
            rescue Bioshogi::BrainProcessingHeavy
              __trace("無理でした")
            end
          end

          unless records.empty?
            unless Rails.env.production?
              tp Bioshogi::Brain.human_format(records)
            end

            record = records.first
            unless Rails.env.production?
              tp record.keys
            end
            hand = record[:hand]

            __trace("#{record[:best_pv].size}手先まで読んで#{hand}を指しました。評価値:#{record[:block_side_score]} 読み筋:#{record[:best_pv].collect(&:to_s).join(' ')}")
          end
        end

        # 読めなかった場合はランダムまたは合法手から選択する
        unless hand
          hands = mediator.current_player.create_all_hands.to_a
          legal = cpu_brain_info.legal_only
          if cpu_brain_info.mate_danger_check
            legal ||= mediator.current_player.mate_danger?
          end
          if legal
            hands = hands.find_all { |e| e.legal_hand?(mediator) }
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

        mediator.execute(hand.to_sfen, executor_class: Bioshogi::PlayerExecutorCpu)
        validate_checkmate_ignore
      end

      tactic_notify
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

    # 戦法を自動発言
    def tactic_notify
      if hand = mediator.hand_logs.last
        hand.skill_set.each do |e|
          e.each do |e|
            active_user.chat_say(battle, e.name, msg_class: "has-text-info")
          end
        end
      end
    end

    # 時間が元に戻る不具合に対応するための案
    # 1. battle_channel.rb で battle をメモ化しない
    # 2. clock_counts_update のところで reload する
    # 3. clock_counts をまるごと送る
    def clock_counts_update(clock_counter)
      Rails.logger.tagged("clock_counts_update") do
        if Rails.env.development?
          if battle.turn_max >= 2
            if battle.clock_counts.values.any? { |e| e.size.zero? }
              raise "2手進んでいるにもかかわらずチェスクロックの片方の手番の情報が入っていない : #{battle.clock_counts}"
            end
          end
          Rails.logger.debug([mediator.opponent_player.location.key, clock_counter, battle.clock_counts])
        end
      end
      battle.clock_counts[mediator.opponent_player.location.key].push(clock_counter) # push でも AR は INSERT 対象になる
      battle.save!
    end

    def mediator_broadcast
      battle.full_sfen = mediator.to_sfen
      battle.turn_max = mediator.turn_info.turn_offset
      battle.save!

      broadcast_hash = {
        :turn_max        => mediator.turn_info.turn_offset,
        :last_hand       => mediator.to_ki2_a.last, # 使ってない
        :full_sfen       => battle.full_sfen,
        :human_kifu_text => battle.human_kifu_text,
        :clock_counts    => battle.clock_counts,
      }

      if battle.yomiage_enable
        broadcast_hash[:yomiage] = mediator.hand_logs.last.yomiage
      end

      ActionCable.server.broadcast(battle.channel_key, broadcast_hash)
    end

    def __trace(message)
      return if Rails.env.production?
      active_user.chat_say(battle, message, msg_class: "has-text-danger")
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

        o.tactic_notify
        o.clock_counts_update(data["clock_counter"].to_i)
        o.mediator_broadcast
        o.win_check

        o.execute_loop_if_robot
      end
    end
  end

  def brain_get(kifu_body)
    begin
      Brain.new(self, Bioshogi::Parser.parse(kifu_body).mediator)
    rescue Bioshogi::BioshogiError => error
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
    users.uniq.each do |e|
      e.chat_say(self, e.end_greeting_message)
    end

    robots = users.find_all { |e| e.race_info.key == :robot }.uniq
    robots.each do |e|
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
    location = Bioshogi::Location.fetch(data["location_key"])
    countdown_flags[location.key] = true
    save!
  end
end
