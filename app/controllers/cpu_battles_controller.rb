class CpuBattlesController < ApplicationController
  helper_method :show_twitter_options
  helper_method :js_cpu_battle

  SHAKING_WIDTH = 0
  TALK_PITCH = 1.5

  def show_twitter_options
    options = {}
    options[:title] = "CPU対戦"
    options[:description] = "ものすごく弱いです"
    options[:image] = ApplicationController.helpers.image_url("cpu_battle_show.png")
    options
  end

  def js_cpu_battle
    {
      player_mode_moved_path: url_for([:cpu_battles, format: "json"]),
      sp_params: sp_params,
      sp_volume: AppConfig[:volume],

      cpu_brain_infos: CpuBrainInfo,
      cpu_brain_key: current_cpu_brain_key,

      cpu_strategy_infos: CpuStrategyInfo,
      cpu_strategy_key: current_cpu_strategy_key,

      cpu_preset_infos: CpuPresetInfo,
      cpu_preset_key: current_cpu_preset_key,
    }
  end

  def sp_params
    {
      board_style_key: params[:board_style_key] || "a",
    }.merge(params.to_unsafe_h.to_options)
  end

  def show
    if false
      talk("talk")
      direct_talk("direct_talk")
    end
  end

  def create
    if v = params[:kifu_body]
      info = Bioshogi::Parser.parse(v)
      begin
        mediator = info.mediator
      rescue => error
        lines = error.message.lines
        error_message = [
          "#{lines.first.remove("【反則】")}",
          # "<br><br>"
          # "<pre>", lines.drop(1).join, "</pre>",
          # "<br>",
          # "<br>",
          '<span class="is-size-7 has-text-grey">※一手戻して再開できます</span>',
        ].join.strip

        # info.move_infos.size - 0

        # before_sfen = Bioshogi::Parser.parse(v, turn_limit: 1).mediator.to_sfen
        # before_sfen = Bioshogi::Parser.parse(v, typical_error_case: :embed).mediator.to_sfen
        # render json: {error_message: error_message, before_sfen: before_sfen}

        final_decision(error_message: error_message)
        return
      end

      yomiage_for(mediator) # 人間の手の読み上げ

      captured_soldier = mediator.opponent_player.executor.captured_soldier
      if captured_soldier
        if captured_soldier.piece.key == :king
          final_decision(you_win_message: "玉を取って勝ちました！", sfen: mediator.to_sfen)
          return
        end
      end

      Rails.logger.info(mediator)
      if current_cpu_brain_info.depth_max_range
        brain = mediator.current_player.brain(diver_class: Bioshogi::NegaScoutDiver, evaluator_class: CustomEvaluator, cpu_strategy_key: cpu_strategy_key_considering_all_round)
        records = []
        time_limit = current_cpu_brain_info.time_limit

        begin
          records = brain.iterative_deepening(time_limit: time_limit, depth_max_range: current_cpu_brain_info.depth_max_range)
        rescue Bioshogi::BrainProcessingHeavy
          time_limit += 1
          Rails.logger.info([:retry, {time_limit: time_limit}])
          retry
        end
        Rails.logger.info(Bioshogi::Brain.human_format(records).to_t)

        if records.empty?
          final_decision(you_win_message: "CPUが投了しました", sfen: mediator.to_sfen)
          return
        end

        # いちばん良いのを選択
        record = records.first
        if record[:score] <= -Bioshogi::INF_MAX
          final_decision(you_win_message: "CPUが降参しました", sfen: mediator.to_sfen)
          return
        end

        if true
          # いちばん良いのが 100 点とすると 95 点まで下げて 95〜100 点の手を改めてランダムで選択する
          min = record[:score] - SHAKING_WIDTH
          record = records.take_while { |e| e[:score] >= min }.sample
        end

        hand = record[:hand]
      else
        hands = mediator.current_player.normal_all_hands.to_a
        if current_cpu_brain_info.legal_only
          hands = hands.find_all { |e| e.legal_move?(mediator) }
        end
        hand = hands.sample
        unless hand
          final_decision(you_win_message: "CPUはもう何も指す手がなかったようです", sfen: mediator.to_sfen)
          return
        end
      end

      # CPUの手を指す
      mediator.execute(hand.to_sfen, executor_class: Bioshogi::PlayerExecutorCpu)
      response = { sfen: mediator.to_sfen }

      yomiage_for(mediator) # CPUの手の読み上げる

      if true
        # 人間側の合法手が生成できなければ人間側の負け
        if mediator.current_player.legal_all_hands.none?
          final_decision(response.merge(you_lose_message: "CPUの勝ちです"))
          return
        end
      end

      captured_soldier = mediator.opponent_player.executor.captured_soldier
      if captured_soldier
        if captured_soldier.piece.key == :king
          final_decision(response.merge(you_lose_message: "玉を取られました"))
          return
        end
      end

      render json: response
      return
    end
  end

  # オールラウンドを考慮した戦法
  def cpu_strategy_key_considering_all_round
    CpuStrategyInfo.fetch_by_params(params).key
  end

  def final_decision(response)
    slack_message(key: "CPU対戦終局", body: response)
    render json: response
  end

  def current_cpu_strategy_info
    CpuStrategyInfo.fetch(current_cpu_strategy_key)
  end

  def current_cpu_strategy_key
    params[:cpu_strategy_key].presence || "居飛車"
  end

  def current_cpu_preset_info
    CpuPresetInfo.fetch(current_cpu_preset_key)
  end

  def current_cpu_preset_key
    params[:cpu_preset_key].presence || CpuPresetInfo.to_a.last&.key
  end

  def current_cpu_brain_info
    CpuBrainInfo.fetch(current_cpu_brain_key)
  end

  def current_cpu_brain_key
    params[:cpu_brain_key].presence || :level3
  end

  private

  def yomiage_for(mediator)
    talk(mediator.hand_logs.last.yomiage, rate: TALK_PITCH) # 人間の手の読み上げ
  end

  class CpuBrainInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :level1, name: "ルールわかってない", time_limit: nil, depth_max_range: nil,  legal_only: false, }, # ランダム
      { key: :level2, name: "ありえないほど弱い", time_limit: nil, depth_max_range: nil,  legal_only: true,  }, # 合法手のランダム
      { key: :level3, name: "めちゃくちゃ弱い",   time_limit: nil, depth_max_range: 0..0, legal_only: nil,   }, # 最初の合法手リストを最善手順に並べたもの
      { key: :level4, name: "かなり弱い",         time_limit:   3, depth_max_range: 0..9, legal_only: nil,   }, # 3秒まで深読みできる
      { key: :level5, name: "弱い",               time_limit:   5, depth_max_range: 0..9, legal_only: nil,   }, # 必ず相手の手を読む
    ]
  end
end
