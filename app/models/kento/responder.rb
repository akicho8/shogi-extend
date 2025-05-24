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
module Kento
  class Responder
    DEFAULT_MAX = 10
    MAX_OF_MAX  = 50

    REQUIRED_HEADER = {
      :api_version => "2020-02-02",
    }

    attr_reader :params

    def initialize(params)
      @params = params
    end

    def call(...)
      as_json(...)
    end

    # http://localhost:3000/w.json?format_type=kento&query=YamadaTaro
    # https://www.shogi-extend.com/w.json?format_type=kento&query=kinakom0chi
    def as_json(*)
      to_h
    end

    private

    def to_h
      @to_h ||= yield_self do
        AppLog.info(subject: "KENTO API", body: [user.key, *notify_params.values].compact.inspect, emoji: ":KENTO_SOME:")
        {
          **REQUIRED_HEADER,
          :api_name  => "将棋ウォーズ(ID:#{user.key})",  # (required) 任意のAPI名
          :game_list => to_a,
        }
      end
    end

    def to_a
      @to_a ||= yield_self do
        s = main_scope
        s = s.joins(:battle)      # for order
        s = s.order(Swars::Battle.arel_table[:battled_at].desc)
        s = s.limit(max)
        s = s.preload(battle: { memberships: [:grade, :user], rule: nil }, judge: nil, taggings: :tag) # battle.title のときに battle.membership.{grade,user} を参照するため
        s.collect(&method(:membership_as_hash))
      end
    end

    def membership_as_hash(membership)
      {
        :tag               => tag_list_of(membership),           # (optional) 任意のタグリスト
        :kifu_url          => membership.battle.kif_url,         # (required) .kif | .csa
        :display_name      => membership.battle.title,           # (required) 任意の表示名
        :display_timestamp => membership.battle.battled_at.to_i, # (required) UNIX タイムスタンプ
      }
    end

    def tag_list_of(membership)
      [
        "将棋ウォーズ(#{membership.battle.rule_info.name})",
        membership.judge_info.name,
        *membership.tag_names_for(:attack).take(1),
      ]
    end

    def max
      [params[:max].presence || DEFAULT_MAX, MAX_OF_MAX].collect(&:to_i).min
    end

    def user
      params.fetch(:user)
    end

    def main_scope
      params[:scope] || user.memberships
    end

    def notify_params
      params[:notify_params] || {}
    end
  end
end
