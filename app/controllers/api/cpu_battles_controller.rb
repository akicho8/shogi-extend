module Api
  class CpuBattlesController < ::Api::ApplicationController
    SHAKING_WIDTH = 0
    TALK_PITCH = 1.5

    def config_params
      {
        :sp_params          => sp_params,

        :cpu_brain_infos    => CpuBrainInfo,
        :cpu_brain_key      => current_cpu_brain_key,

        :cpu_strategy_infos => CpuStrategyInfo,
        :cpu_strategy_key   => current_cpu_strategy_key,

        :cpu_preset_infos   => CpuPresetInfo,
        :cpu_preset_key     => current_cpu_preset_key,

        :judge_group        => CpuBattleRecord.group(:judge_key).count,
      }
    end

    def sp_params
      {}.merge(params.to_unsafe_h.to_options)
    end

    # curl -s "http://localhost:3000/api/cpu_battle?config_fetch=true" | jq .
    def show
      if params[:config_fetch]
        render json: config_params
        return
      end

      if false
        talk("talk")
        direct_talk("direct_talk")
      end
    end

    def create
      if params[:start_trigger]
        logging("開始")
        return
      end

      if params[:resign_trigger]
        final_decision(judge_key: :lose, message: "負けました")
        return
      end

      if params[:candidate_sfen]
        candidate_process
        return
      end

      if params[:kifu_body]
        cpu_process
        return
      end
    end

    # オールラウンドを考慮した戦法
    def cpu_strategy_key_considering_all_round
      CpuStrategyInfo.fetch_by_params(params).key
    end

    def final_decision(response)
      response = build_response.merge(response)

      cpu_battle_record = CpuBattleRecord.create!(judge_key: response[:judge_key], user: current_user)
      judge_info = JudgeInfo[response[:judge_key]]
      logging("終局", "[#{judge_info}] #{response[:message]}")

      response[:judge_group] = CpuBattleRecord.group(:judge_key).count

      render json: response
    end

    def current_cpu_strategy_info
      CpuStrategyInfo.fetch(current_cpu_strategy_key)
    end

    def current_cpu_strategy_key
      params[:cpu_strategy_key].presence || "オールラウンド"
    end

    def current_cpu_preset_info
      CpuPresetInfo.fetch(current_cpu_preset_key)
    end

    def current_cpu_preset_key
      params[:cpu_preset_key].presence || CpuPresetInfo.to_a.first&.key
    end

    def current_cpu_brain_info
      CpuBrainInfo.fetch(current_cpu_brain_key)
    end

    def current_cpu_brain_key
      params[:cpu_brain_key].presence || :level3
    end

    private

    def cpu_process
      @candidate_records = []
      @current_sfen = params[:kifu_body]
      @hand = nil
      @score_list = []

      info = Bioshogi::Parser.parse(@current_sfen)
      begin
        @container = info.container
      rescue => error
        lines = error.message.lines
        message = [
          "#{lines.first.remove("【反則】")}",
          # "<br><br>"
          # "<pre>", lines.drop(1).join, "</pre>",
          # "<br>",
          # "<br>",
          # '<span class="is-size-7 has-text-grey">※一手戻して再開できます</span>',
        ].join.strip

        # info.pi.move_infos.size - 0

        # before_sfen = Bioshogi::Parser.parse(v, turn_max: 1).container.to_history_sfen
        # before_sfen = Bioshogi::Parser.parse(v, typical_error_case: :embed).container.to_history_sfen
        # render json: {failure_message: failure_message, before_sfen: before_sfen}

        final_decision(judge_key: :lose, irregular: true, message: message)
        return
      end

      # Rails.logger.debug(@container.turn_info.inspect)

      if Rails.env.production? || Rails.env.staging?
      else
        Rails.logger.debug(@container)
      end

      yomiage_process # 人間の手の読み上げ

      evaluation_value_generation

      if executor = @container.opponent_player.executor # 1回でも手を指さないと executor は入っていないため
        captured_soldier = executor.captured_soldier
        if captured_soldier
          if captured_soldier.piece.key == :king
            final_decision(judge_key: :win, message: "玉を取って勝ちました！")
            return
          end
        end
      end

      if !@hand
        if current_cpu_brain_info.mate_danger_check
          @hand = @container.current_player.king_capture_move_hands.first

          # 玉を取らない場合
          if false
            if @hand
              final_decision(judge_key: :lose, message: "王手放置(または自殺手)で負けました")
              return
            end
          end
        end
      end

      if !@hand
        if current_cpu_brain_info.depth_max_range
          iterative_deepening

          if Rails.env.production? || Rails.env.staging?
          else
            Rails.logger.debug(candidate_report)
          end

          if @candidate_records.empty?
            final_decision(judge_key: :win, message: "CPUが投了しました")
            return
          end

          # いちばん良いのを選択
          record = @candidate_records.first
          if record[:score] <= -Bioshogi::AI::SCORE_MAX
            final_decision(judge_key: :win, message: "CPUが降参しました")
            return
          end

          if true
            # いちばん良いのが 100 点とすると 95 点まで下げて 95〜100 点の手を改めてランダムで選択する
            min = record[:score] - SHAKING_WIDTH
            record = @candidate_records.take_while { |e| e[:score] >= min }.sample
          end

          @hand = record[:hand]
        end
      end

      if !@hand
        hands = @container.current_player.create_all_hands.to_a
        if current_cpu_brain_info.legal_only
          hands = hands.find_all { |e| e.legal_hand?(@container) }
        end
        @hand = hands.sample
      end

      if !@hand
        final_decision(judge_key: :win, message: "CPUが投了しました。もう何も指す手がなかったようです")
        return
      end

      # CPUの手を指す
      @container.execute(@hand.to_sfen, executor_class: Bioshogi::PlayerExecutor::Human)
      @current_sfen = @container.to_history_sfen
      evaluation_value_generation

      yomiage_process # CPUの手の読み上げる

      captured_soldier = @container.opponent_player.executor.captured_soldier
      if captured_soldier
        if captured_soldier.piece.key == :king
          final_decision(judge_key: :lose, message: "玉を取られました")
          return
        end
      end

      if current_cpu_brain_info.mate_danger_check
        # 人間側の合法手が生成できなければ人間側の負け
        if @container.current_player.legal_all_hands.none?
          final_decision(judge_key: :lose, message: "CPUの勝ちです")
          return
        end
      end

      render json: build_response
    end

    def candidate_process
      info = Bioshogi::Parser.parse(params[:candidate_sfen])
      begin
        @container = info.container
      rescue => error
        render json: build_response
        return
      end

      if current_cpu_brain_info.depth_max_range
        iterative_deepening
      end

      render json: build_response
    end

    def iterative_deepening
      brain = @container.current_player.brain(diver_class: Bioshogi::AI::Diver::NegaScoutDiver, **evaluator_params)
      time_limit = current_cpu_brain_info.time_limit

      begin
        @candidate_records = brain.iterative_deepening(time_limit: time_limit, depth_max_range: current_cpu_brain_info.depth_max_range)
      rescue Bioshogi::BrainProcessingHeavy
        time_limit += 1
        Rails.logger.info([:retry, { time_limit: time_limit }])
        retry
      end
    end

    def logging(title, body = nil)
      AppLog.info(subject: "CPU対戦 - #{title}", body: [logging_body_prefix, body].join)
    end

    def logging_body_prefix
      [
        current_user,
        current_cpu_brain_info,
        current_cpu_strategy_info,
        current_cpu_preset_info,
      ].compact.collect { |e| "[#{e.name}]" }.join
    end

    def evaluation_value_generation
      @score_list << { x: @container.turn_info.turn_offset, y: @container.player_at(:black).evaluator.score }
    end

    # 最後の手があれば読み上げる
    def yomiage_process
      if params[:yomiage_mode]
        if last = @container.hand_logs.last

          # 方法1
          if false
            if last.tag_bundle
              last.tag_bundle.each do |e|
                e.each do |e|
                  talk(e.name)
                end
              end
            end
          end

          # 方法2
          if false
            if last.tag_bundle
              names = last.tag_bundle.flat_map { |e| e.collect(&:name) }
              names = names.reject { |e| e.in?(["居飛車", "振り飛車"]) }
              if names.present?
                # sfx_play(:shine) # このメソッドはない
                talk(names.join("、"))
                names.each { |e| toast_message(e) }
              end
            end
          end

          if Rails.env.development? && false
            talk(last.yomiage, rate: TALK_PITCH)
          end
        end
      end
    end

    def build_response
      response = {}

      if @current_sfen
        response[:current_sfen] = @current_sfen
      end

      if @score_list
        response[:score_list] = @score_list
      end

      response[:candidate_rows] = candidate_rows     # 古いままの状態が続かないように必ず設定してビューに渡す (b-table用)

      if @container
        response[:pressure_rate_hash] = @container.players.inject({}) { |a, e| a.merge(e.location.key => e.pressure_rate) }
        response[:turn_offset] = @container.turn_info.turn_offset
      end

      if Rails.env.production? || Rails.env.staging?
      else
        response[:candidate_report] = candidate_report # そのまま表示できるテキスト
        # response[:pressure_rate_hash] = @container.players.inject({}) { |a, e| a.merge(e.location.key => rand(0..1.0)) }
        if @container
          response[:think_text] = [
            @container.current_player.evaluator(evaluator_params).score_compute_report.to_t,
            @container.players.inject({}) { |a, e| a.merge(e.location => e.pressure_rate) }.to_t,
            *@container.players.collect { |e| e.pressure_report.to_t },
          ].join
        end
      end

      response
    end

    def candidate_report
      @candidate_report ||= candidate_rows.to_t
    end

    # FIXME: なんか書き方が汚ならしい
    def candidate_rows
      @candidate_rows ||= yield_self do
        if @candidate_records.present?
          Bioshogi::AI::Brain.human_format(@candidate_records.take(5)).collect { |e|
            e.collect { |key, val|
              if key == "候補手"
                val = val.to_s    # ビューに as_json の結果が渡ってしまうので文字列にしておく
              end
              [key, val]
            }.compact.to_h
          }
        end
      end
    end

    def evaluator_params
      {
        evaluator_class: CustomEvaluator,
        cpu_strategy_key: cpu_strategy_key_considering_all_round,
      }
    end

    class CpuBrainInfo
      include ApplicationMemoryRecord
      memory_record [
        { key: :level1,  name: "ルールわかってない", time_limit: nil, depth_max_range: nil,  legal_only: false, mate_danger_check: false, development_only: false, }, # ランダム
        { key: :level2,  name: "ありえないほど弱い", time_limit: nil, depth_max_range: nil,  legal_only: true,  mate_danger_check: true,  development_only: false, }, # 合法手のランダム
        { key: :level3,  name: "めちゃくちゃ弱い",   time_limit: nil, depth_max_range: 0..0, legal_only: nil,   mate_danger_check: true,  development_only: false, }, # 最初の合法手リストを最善手順に並べたもの
        { key: :level4,  name: "かなり弱い",         time_limit:   3, depth_max_range: 0..9, legal_only: nil,   mate_danger_check: true,  development_only: true,  }, # 3秒まで深読みできる
        { key: :level5,  name: "弱い",               time_limit:   5, depth_max_range: 0..9, legal_only: nil,   mate_danger_check: true,  development_only: true,  }, # 必ず相手の手を読む
        { key: :level5a, name: "1手読み(TLE無)",     time_limit: nil, depth_max_range: 1..1, legal_only: nil,   mate_danger_check: true,  development_only: true,  }, # 必ず1手読
        { key: :level6,  name: "長考10秒",           time_limit:  10, depth_max_range: 0..9, legal_only: nil,   mate_danger_check: true,  development_only: true,  }, # 長考
        { key: :level7,  name: "長考30秒",           time_limit:  30, depth_max_range: 0..9, legal_only: nil,   mate_danger_check: true,  development_only: true,  }, # 長考
        { key: :level8,  name: "長考1分",            time_limit:  60, depth_max_range: 0..9, legal_only: nil,   mate_danger_check: true,  development_only: true,  }, # 長考
      ]

      def self.values
        v = super
        if Rails.env.production? || Rails.env.staging?
          v = v.reject(&:development_only)
        end
        v
      end
    end
  end
end
