module AdapterMod
  extend ActiveSupport::Concern

  def adapter_process
    return_redirect_params_if_official_swars_battle_url_included
    if performed?
      return
    end

    current_record.assign_attributes(kifu_body: current_input_text)
    if current_record.save
      all_kifs = current_record.all_kifs # エラーにならないことを確認する目的もある
      ok_notify
      sleep(1) if Rails.env.development?
      render json: { all_kifs: all_kifs, record: js_record_for(current_record) }
      return
    else
      # ここに来ることはない……ことない
      render json: { bs_error: {message: current_record.errors.full_messages.join(" ")} }
      return
    end

  rescue Bioshogi::BioshogiError => error
    sleep(0.5) if Rails.env.development?
    ng_notify(error)
    render json: as_shogi_error_attrs(error)
    return
  end

  private

  def return_redirect_params_if_official_swars_battle_url_included
    # 自動的に飛ばすとそれが正規の方法だと思う人がでてくる問題ありか……？
    if current_input_text.lines.count <= 2
      if url = Swars::Battle.battle_url_extract(current_input_text)
        slack_message(key: "なんでも棋譜変換にウォーズの対局URL入力した方を検知", body: current_input_text)
        if Rails.env.development?
          flash[:warning] = "ウォーズの対局URLはこちらに入力してください"
        end
        render json: { redirect_to: url_for([:swars, :battles, query: current_input_text]) }
      end
    end
  end

  def ok_notify
    return if current_input_text.blank?

    lines = current_input_text.lines
    body = (lines.take(8) + ["(snip)\n"] + lines.last(3)).join
    if current_record.turn_max.zero?
      channel = "#adapter_error"
    else
      channel = "#adapter_success"
    end
    slack_message(key: "変換#{current_record.turn_max}手", body: body, channel: channel)
  end

  def ng_notify(error)
    return if current_input_text.blank?

    slack_message(key: error.class.name, body: "#{error.message}\n----\n#{current_input_text}", channel: "#adapter_error")
  end
end
