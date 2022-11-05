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
#      "kifu_url":"https://sample.com/xxx.csa",     // (required) .kif | .csa
#      "display_name":"▲na_o_ys(1515)△xxx(1559)", // (required) 任意の表示名
#      "display_timestamp":1577460035               // (required) UNIX タイムスタンプ
#    }
#  ]
# }
#
# こんな感じのJSONをGETで返すAPIを用意して、KENTO[設定]ページの[API追加]ボタンよりURLを登録すると、KENTOの[棋譜一覧]ページに棋譜が追加されます。
#
module Swars
  class KentoApi
    KENTO_RECORDS_MAX_DEFAULT = 20
    KENTO_RECORDS_MAX_OF_MAX  = 50

    attr_accessor :controller

    def initialize(params = {})
      @params = params
      @user  = params[:user]
      @scope = params[:scope] || @user.battles
      @max   = params[:max]
    end

    def as_json(*)
      @counter = Battle.continuity_run_counter("kento")
      import_process
      if (@counter >= 45 && @counter.pred.modulo(10).zero?) || Rails.env.test?
        body = [@params[:remote_ip], Time.current.strftime("%H:%M:%S"), @user.key].join(" ")
        SlackAgent.notify(subject: "KENTO API(#{@counter})", body: body)
      end
      to_h.as_json
    end

    private

    def to_h
      {
        "api_version" => "2020-02-02",                     # (required) 固定値
        "api_name"    => "将棋ウォーズ(ID:#{@user.key})",  # (required) 任意のAPI名
        "game_list"   => @scope.order(battled_at: :desc).limit(current_max).collect(&method(:membership_for)),
      }
    end

    def membership_for(battle)
      membership = battle.memberships.find { |e| e.user == @user }
      {
        "tag"               => tag_list_for(battle, membership),     # (optional) 任意のタグリスト
        "kifu_url"          => battle.kif_url,                       # (required) .kif | .csa
        "display_name"      => battle.title,                         # (required) 任意の表示名
        "display_timestamp" => battle.battled_at.to_i,               # (required) UNIX タイムスタンプ
      }
    end

    def tag_list_for(battle, membership)
      [
        "将棋ウォーズ(#{battle.rule_info.name})",
        membership.judge_info.name,
        *membership.tag_names_for(:attack).take(1),
      ]
    end

    def import_process
      # KENTOは連続アクセスしてくるためすべてクロールするのは現実的ではない
      # ウォーズ検索のクロール待ち時間と分けるためIPで判別しようかと思ったがIPはほぼランダムに変わる
      if @counter == 1
        # slack_notify(subject: "KENTOアクセス元IP", body: request.remote_ip)
        Swars::Importer::ThrottleImporter.new(user_key: @user.key, page_max: 1).run
      end
    end

    def current_max
      [@max.presence || KENTO_RECORDS_MAX_DEFAULT, KENTO_RECORDS_MAX_OF_MAX].collect(&:to_i).min
    end
  end
end
