# (開発者向け)棋譜リストAPI
# https://note.com/shogi_kento/n/nea5e736f5311
#
# {
#  "api_version":"2020-02-02",                      // (required) 固定値
#  "api_name":"将棋クエスト(ID:na_o_ys)",             // (required) 任意のAPI名
#  "game_list":[
#    {
#      "tag":[                                      // (optional) 任意のタグリスト
#        "将棋クエスト(10分)",
#        "負け"
#      ],
#      "kifu_url":"https://sample.com/XXX.csa",     // (required) .kif | .csa
#      "display_name":"▲na_o_ys(1515)△XXX(1559)",   // (required) 任意の表示名
#      "display_timestamp":1577460035               // (required) UNIX タイムスタンプ
#    }
#  ]
# }
#
# こんな感じのJSONをGETで返すAPIを用意して、KENTO[設定]ページの[API追加]ボタンよりURLを登録すると、KENTOの[棋譜一覧]ページに棋譜が追加されます。

module KentoJsonMod
  extend ActiveSupport::Concern

  private

  # http://localhost:3000/w.json?query=devuser1&json_format_type=kento
  # http://tk2-221-20341.vs.sakura.ne.jp/shogi/w.json?query=kinakom0chi&json_format_type=kento
  def kento_json_render
    if request.format.json? && params[:json_format_type] == "kento"
      if current_swars_user
        import_process2(flash)

        json_hash = {
          "api_version" => "2020-02-02",                      # (required) 固定値
          "api_name" => "将棋ウォーズ(ID:#{current_swars_user.user_key})",             # (required) 任意のAPI名
          "game_list" => current_index_scope.order(battled_at: "desc").limit(10).collect { |e|
            {
              "tag": [                                      # (optional) 任意のタグリスト
                "将棋ウォーズ(#{e.rule_info.name})",
                e.win_user == current_swars_user ? "勝ち" : "負け", # 雑
              ],
              "kifu_url"          => full_url_for([e, format: "kif"]),     # (required) .kif | .csa
              "display_name"      => e.title,   # (required) 任意の表示名
              "display_timestamp" => e.battled_at.to_i, # (required) UNIX タイムスタンプ
            }
          },
        }

        # render json: {ok: 1}.as_json
        render json: json_hash.as_json
        return
      end
    end
  end

  # # curl -I http://localhost:3000/x/1.kif?inline=1
  # # curl -I http://localhost:3000/x/1.kif?plain=1
  # def kif_data_send
  #   text_body = current_record.to_cached_kifu(params[:format])
  #
  #   if as_b(params[:copy_trigger])
  #     slack_message(key: "#{params[:format]}コピー", body: current_record.title)
  #   end
  #
  #   if current_body_encode == :sjis
  #     text_body = text_body.tosjis
  #   end
  #
  #   # if as_b(params[:plain])
  #   #   render plain: text_body
  #   #   return
  #   # end
  #
  #   if current_disposition == :inline
  #     headers["Content-Type"] = current_type
  #     render plain: text_body
  #     return
  #   end
  #
  #   # inline でこれを表示すると headers["Content-Transfer-Encoding"] = "binary" になっているため Capybara でテキストが文字化けする
  #   # send_data(text_body, type: Mime[params[:format]], filename: current_filename.public_send("to#{filename_encode}"), disposition: current_disposition)
  #   send_data(text_body, type: current_type, filename: current_filename.public_send("to#{filename_encode}"), disposition: current_disposition)
  # end
  #
  # def current_type
  #   if current_body_encode == :sjis
  #     "text/plain; charset=Shift_JIS"
  #   else
  #     "text/plain; charset=UTF-8"
  #   end
  # end
  #
  # def current_disposition
  #   value = params[:disposition]
  #
  #   unless value
  #     if key = [:inline, :attachment].find { |e| as_b(params[e]) }
  #       value ||= key
  #     end
  #   end
  #
  #   (value || :inline).to_sym
  # end
  #
  # def current_filename
  #   "#{current_record.to_param}.#{params[:format]}"
  # end
  #
  # def filename_encode
  #   (params[:filename_encode].presence || filename_encode_default).to_sym
  # end
  #
  # def filename_encode_default
  #   if filename_sjis?
  #     :sjis
  #   else
  #     :utf8
  #   end
  # end
  #
  # def filename_sjis?
  #   request.user_agent.to_s.match?(/Windows/i) || as_b(params[:shift_jis]) || as_b(params[:sjis])
  # end
  #
  # def current_body_encode
  #   (params[:body_encode].presence || :utf8).to_sym
  # end
end
