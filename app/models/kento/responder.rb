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

    class << self
      def call(...)
        new(...).call
      end
    end

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
        hv = nil
        bmx = Bmx.call { hv = to_h_without_measurement }
        body = [bmx, user.key, to_a.size, *information_to_add_to_the_log.values]
        AppLog.info(subject: "KENTO API", body: body.compact.inspect, emoji: ":KENTO_SOME:")
        hv
      end
    end

    def to_h_without_measurement
      {
        **REQUIRED_HEADER,
        :api_name  => "将棋ウォーズ(ID:#{user.key})",  # (required) 任意のAPI名
        :game_list => to_a,
      }
    end

    def to_a
      @to_a ||= yield_self do
        s = user.memberships
        s = s.order(Swars::Battle.arel_table[:battled_at].desc)
        s = s.limit(max)
        s = s.includes(battle: { memberships: [:grade, :user], rule: nil }, judge: nil) # battle.title のときに battle.membership.{grade,user} を参照するため
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
        "将棋ウォーズ(#{membership.battle.rule.name})",
        membership.judge.name,
      ]
    end

    def max
      [params[:max].presence || DEFAULT_MAX, MAX_OF_MAX].collect(&:to_i).min
    end

    def user
      params.fetch(:user)
    end

    def information_to_add_to_the_log
      params[:information_to_add_to_the_log] || {}
    end
  end
end
