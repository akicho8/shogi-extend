module Ppl
  class Spider
    BASE_GENERATION = 28
    OLD_TYPE_GENERATIONS = [28, 30]

    attr_reader :params

    def initialize(params = {})
      @params = {
        :max     => 256,
        :verbose => Rails.env.development? || Rails.env.staging? || Rails.env.production?,
        :sleep   => (Rails.env.development? || Rails.env.staging? || Rails.env.production?) ? 1 : 0,
      }.merge(params)
    end

    def call
      if str = html_fetch
        Nokogiri::HTML(str).search("tbody tr").take(max).collect do |tr_el|
          attributes_from(tr_el)
        end
      end
    end

    def source_url
      "https://www.shogi.or.jp/match/shoreikai/sandan/#{season_number}/index.html"
    end

    private

    def attributes_from(tr)
      {}.tap do |attrs|
        values = tr.search("td").collect { |e| e.text.remove(/\p{Space}+/) }
        attrs.update(column_names.zip(values).to_h)
        attrs[:result_key] = attrs[:result_key].presence || "維"
        attrs[:ox] = win_lose_normalize(values.join)
        integer_type_column_names.each do |e|
          if v = attrs[e]
            attrs[e] = v.to_i
          end
        end
      end
    end

    # 昔と今でフォーマットが異なる
    # ・昔 https://www.shogi.or.jp/match/shoreikai/sandan/28/index.html
    # ・今 https://www.shogi.or.jp/match/shoreikai/sandan/66/index.html
    #
    # 2回目の次点が「昇」マークになっている問題
    # 次点についても表記が統一されておらず次点の2回目では「次」と表示せずに「昇」としている
    # 例: https://www.shogi.or.jp/match/shoreikai/sandan/72/index.html
    # 「柵木幹太」は次点2回目で権利を取得しただけにもかかわらず「昇」のマークを入れてしまっているため、
    # 次点2回目なのか2位以内に入ったことで昇段なのか判断できない
    def column_names
      @column_names ||= yield_self do
        if season_number.in?(OLD_TYPE_GENERATIONS)
          [:result_key, :start_pos, :name, :win, :lose]
        else
          [:result_key, :start_pos, :name, :_mentor, :age, :win, :lose] # _mentor は未使用
        end
      end
    end

    def integer_type_column_names
      [:age, :win, :lose, :start_pos]
    end

    def max
      (params[:max].presence || 256).to_i
    end

    def season_number
      params.fetch(:season_number).to_i
    end

    # 当初ここをキャッシュしていたがそれは設計ミス
    # 毎回呼ぶわけではないのでキャッシュする意味がないし大量にメモリを消費するため割に合わない
    def html_fetch
      if Rails.env.test?
        return Pathname("#{__dir__}/mock/mock_index.html").read.toutf8
      end

      if params[:verbose]
        tp({ "期" => season_number, "URL" => source_url, sleep: params[:sleep] })
      end

      sleep(params[:sleep])

      URI(source_url).read.toutf8 # この時点で UTF-8 にしておかないと fastentry が死ぬ
    end

    # 連盟は手動で作っているため勝ち負けの表記がバラバラである
    def win_lose_normalize(str)
      str.scan(/[○□●■]/).join.tr("○□●■", "ooxx")
    end
  end
end
