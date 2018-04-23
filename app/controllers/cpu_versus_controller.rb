class CpuVersusController < ApplicationController
  def show
    @cpu_versus_app_params = {
      player_mode_moved_path: url_for([:cpu_versus, format: "json"]),
    }
  end

  def create
    if v = params[:kifu_body]
      info = Warabi::Parser.parse(v, typical_error_case: :embed)
      begin
        mediator = info.mediator
      rescue => error
        render json: {error_message: error.message}
        return
      end

      captured_soldier = mediator.opponent_player.executor.captured_soldier
      if captured_soldier
        if captured_soldier.piece.key == :king
          render json: {normal_message: "玉を取られたので負けました", sfen: mediator.to_sfen}
          return
        end
      end

      if true
        puts mediator
        brain = mediator.current_player.brain(diver_class: Warabi::NegaScoutDiver, evaluator_class: Warabi::EvaluatorAdvance)
        records = []
        time_limit = current_cpu_tuyosa_info.time_limit
        begin
          records = brain.iterative_deepening(time_limit: time_limit, depth_max_range: current_cpu_tuyosa_info.depth_max_range)
        rescue Warabi::BrainProcessingHeavy
          time_limit += 1
          p [:retry, {time_limit: time_limit}]
          retry
        end
        tp Warabi::Brain.human_format(records)

        if records.empty?
          render json: {normal_message: "もう指す手がありません。負けました(T_T)", sfen: mediator.to_sfen}
          return
        end

        record = records.first
        if record[:score] <= -Warabi::INF_MAX
          render json: {normal_message: "降参です。負けました(T_T)", sfen: mediator.to_sfen}
          return
        end

        hand = record[:hand]
      else
        # ランダムに指す
        # hands = mediator.current_player.normal_all_hands
        # hand = hands.to_a.shuffle.find { |e| e.legal_move?(mediator) }
      end

      # CPUの手を指す
      mediator.execute(hand.to_sfen, executor_class: Warabi::PlayerExecutorCpu)

      if true
        # 人間側の合法手が生成できなければ人間側の負け
        if mediator.current_player.legal_all_hands.none?
          render json: {normal_message: "CPUの勝ちです", sfen: mediator.to_sfen}
          return
        end
      end

      captured_soldier = mediator.opponent_player.executor.captured_soldier
      if captured_soldier
        if captured_soldier.piece.key == :king
          render json: {normal_message: "CPUの勝ちです", sfen: mediator.to_sfen}
          return
        end
      end

      render json: {sfen: mediator.to_sfen}
      return
    end
  end

  def current_cpu_tuyosa_info
    CpuTuyosaInfo.fetch(current_cpu_tuyosa_key)
  end

  def current_cpu_tuyosa_key
    params[:cpu_tuyosa_key].presence || :yowai
  end

  class CpuTuyosaInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :yowai, name: "弱い", time_limit: nil, depth_max_range: 0..0 }, # 最初の合法手リストを最善手順に並べたもの
      { key: :hutuu, name: "普通", time_limit:   3, depth_max_range: 0..9 }, # 3秒まで深読みできる
      { key: :tuyoi, name: "強い", time_limit:   5, depth_max_range: 0..9 }, # 必ず相手の手を読む
    ]
  end
end
