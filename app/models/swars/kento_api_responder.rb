# (開発者向け)棋譜リストAPI
# https://note.com/shogi_kento/n/nea5e736f5311
#
#   {
#    "api_version":"2020-02-02",                      // (required) 固定値
#    "api_name":"将棋クエスト(ID:na_o_ys)",           // (required) 任意のAPI名
#    "game_list":[
#      {
#        "tag":[                                      // (optional) 任意のタグリスト
#          "将棋クエスト(10分)",
#          "負け"
#        ],
#        "kifu_url":"https://sample.com/xxx.csa",     // (required) .kif | .csa
#        "display_name":"▲na_o_ys(1515)△xxx(1559)", // (required) 任意の表示名
#        "display_timestamp":1577460035               // (required) UNIX タイムスタンプ
#      }
#    ]
#   }
#
# こんな感じのJSONをGETで返すAPIを用意して、KENTO[設定]ページの[API追加]ボタンよりURLを登録すると、KENTOの[棋譜一覧]ページに棋譜が追加されます。
#
module Swars
  class KentoApiResponder
    DEFAULT_MAX = 10
    MAX_OF_MAX  = 50
    BLACK_LIST  = /.*|maruded|Lesser_panda20|Tiffblue|katsudon_kuitai|Icy_tail|shogi_priest|champion2020|StaySea|ribako1210|si_kun_YouTuber|karma99/

    def initialize(params = {})
      @user          = params.fetch(:user)
      @scope         = params[:scope] || @user.battles
      @max           = params[:max]
      @notify_params = params[:notify_params] || {}
    end

    def call(...)
      as_json(...)
    end

    # http://localhost:3000/w.json?format_type=kento&query=YamadaTaro
    # https://www.shogi-extend.com/w.json?format_type=kento&query=kinakom0chi
    def as_json(*)
      to_h_with_benchmark
    end

    def black_user?
      BLACK_LIST.match?(@user.key)
    end

    def white_user?
      !black_user?
    end

    private

    def to_h_with_benchmark
      count = @user.battles.count
      response = nil
      sec = Benchmark.realtime { response = to_h }
      diff = @user.battles.count - count
      emoji = @crawled ? ":KENTO_SOME:" : ":KENTO_NONE:"
      body = [@user.key, "%+d" % diff, "%.1f s" % sec, *@notify_params.values].compact.inspect
      AppLog.info(subject: "KENTO API", body: body, emoji: emoji)
      response
    end

    def to_h
      if white_user?
        @crawled = Swars::Importer::ThrottleImporter.new(user_key: @user.key, page_max: 1).call
      end
      {
        "api_version" => "2020-02-02",                     # (required) 固定値
        "api_name"    => "将棋ウォーズ(ID:#{@user.key})",  # (required) 任意のAPI名
        "game_list"   => game_list,
      }
    end

    def game_list
      @scope.order(battled_at: :desc).limit(current_max).collect(&method(:membership_for))
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

    def current_max
      [@max.presence || DEFAULT_MAX, MAX_OF_MAX].collect(&:to_i).min
    end
  end
end
