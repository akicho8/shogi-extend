# これはもう使ってない？

module AdapterMethods
  extend ActiveSupport::Concern

  def adapter_process
    return_redirect_params_if_official_swars_battle_url_included
    if performed?
      return
    end

    current_record.update!(kifu_body: current_input_text)
    all_kifs = current_record.all_kifs # エラーにならないことを確認する目的もある
    ok_notify
    sleep(1) if Rails.env.development?
    render json: { all_kifs: all_kifs, record: js_record_for(current_record) }
  end

  private

  # def return_redirect_params_if_official_swars_battle_url_included
  #   # 自動的に飛ばすとそれが正規の方法だと思う人がでてくる問題ありか……？
  #   if current_input_text.lines.count <= 2
  #     if url = Swars::BattleUrl.url(current_input_text)
  #       AppLog.info(subject: "なんでも棋譜変換にウォーズの対局URL入力した方を検知", body: current_input_text)
  #       if Rails.env.development?
  #         flash[:warning] = "ウォーズの対局URLはこちらに入力しよう"
  #       end
  #       render json: { redirect_to: url_for([:swars, :battles, query: current_input_text]) }
  #     end
  #   end
  # end

  def ok_notify
    return if current_input_text.blank?

    lines = current_input_text.lines
    body = (lines.take(8) + ["(snip)\n"] + lines.last(3)).join
    if current_record.turn_max.zero?
      channel = "#adapter_error"
    else
      channel = "#adapter_success"
    end
    AppLog.info(subject: "変換#{current_record.turn_max}手", body: body, channel: channel)
  end
end
