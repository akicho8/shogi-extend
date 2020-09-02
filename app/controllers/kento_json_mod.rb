# TODO: modelに移動

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

  mattr_accessor(:kento_records_max)        { 20 }
  mattr_accessor(:kento_records_max_of_max) { 50 }

  private

  # http://localhost:3000/w.json?query=user1&format_type=kento
  # https://www.shogi-extend.com/w.json?query=kinakom0chi&format_type=kento
  def kento_json_render
    if request.format.json? && format_type == "kento"
      if current_swars_user
        ip = request.remote_ip
        counter = Swars::Battle.continuity_run_counter("kento")
        if counter == 1
          slack_message(key: "KENTOアクセス元IP", body: ip)
          Swars::Battle.sometimes_user_import(user_key: current_swars_user.key, page_max: 1)
        end

        json_hash = {
          "api_version" => "2020-02-02",                                    # (required) 固定値
          "api_name" => "将棋ウォーズ(ID:#{current_swars_user.key})",  # (required) 任意のAPI名
          "game_list" => current_index_scope.order(battled_at: "desc").limit(kento_records_limit).collect { |e|
            membership = current_swars_user_membership(e)
            {
              "tag": [                                                      # (optional) 任意のタグリスト
                "将棋ウォーズ(#{e.rule_info.name})",
                membership.judge_info.name,
                *membership.tag_names_for(:attack).take(1),
              ],
              "kifu_url"          => full_url_for([e, format: "kif"]),      # (required) .kif | .csa
              "display_name"      => e.title,                               # (required) 任意の表示名
              "display_timestamp" => e.battled_at.to_i,                     # (required) UNIX タイムスタンプ
            }
          },
        }

        if counter >= 45 && counter.pred.modulo(10).zero?
          slack_message(key: "KENTO API(#{counter})", body: [ip, Time.current.strftime("%H:%M:%S"), current_swars_user.key].join(" "))
        end
        render json: json_hash.as_json
        return
      end
    end
  end

  def current_swars_user_membership(battle)
    battle.memberships.find { |e| e.user == current_swars_user }
  end

  def format_type
    params[:format_type]
  end

  def kento_records_limit
    [params[:limit].presence || kento_records_max, kento_records_max_of_max].collect(&:to_i).min
  end
end
