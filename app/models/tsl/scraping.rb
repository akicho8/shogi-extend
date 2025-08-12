module Tsl
  class Scraping
    cattr_accessor(:league_range)  do
      if Rails.env.production? || Rails.env.staging?
        28..100
      elsif Rails.env.test?
        [66]
      else
        [28, 66, 67, 68]
      end
    end

    attr_accessor :params

    def initialize(params = {})
      @params = params
    end

    def user_infos
      if html = html_fetch
        doc = Nokogiri::HTML(html)
        doc.search("tbody tr").take(rows_max).collect do |tr|
          {}.tap do |user|
            values = tr.search("td").collect do |e|
              e.text.remove(/\p{Space}+/)
            end

            # 昔と今でフォーマットが異なる
            # ・昔 https://www.shogi.or.jp/match/shoreikai/sandan/28/index.html
            # ・今 https://www.shogi.or.jp/match/shoreikai/sandan/66/index.html
            if generation.in?([28, 30])
              columns = [:result_key, :start_pos, :name, :win, :lose]
            else
              columns = [:result_key, :start_pos, :name, :parent, :age, :win, :lose]
            end
            user.update(columns.zip(values).to_h)

            user[:ox] = values.join.scan(/[○□●■]/).join.tr("○□●■", "ooxx") # 謎の四角が含まれる(表記ミス？)

            # 勝敗のマークから勝数を調べる場合
            if false
              user[:win]  = user[:ox].count("○")
              user[:lose] = user[:ox].count("●")
            end

            user[:name] = NameNormalizer.normalize(user[:name])
            user[:result_key] = result_key_normalize(user[:result_key])

            [:age, :win, :lose, :start_pos].each do |e|
              if v = user[e]
                user[e] = v.to_i
              end
            end
          end
        end
      end
    end

    def source_url
      "https://www.shogi.or.jp/match/shoreikai/sandan/#{generation}/index.html"
    end

    private

    def rows_max
      (params[:rows_max].presence || 256).to_i
    end

    def generation
      (params[:generation].presence || league_range.last).to_i
    end

    def html_fetch
      if Rails.env.test?
        return Pathname("#{__dir__}/mock/mock_index.html").read.toutf8
      end

      Rails.cache.fetch(source_url, :expires_in => 1.hour) do
        begin
          URI(source_url).read.toutf8 # この時点で UTF-8 にしておかないと fastentry が死ぬ
        rescue OpenURI::HTTPError, SocketError
        end
      end
    end

    def result_key_normalize(key)
      key = key.to_s
      {
        "昇" => "昇段",
        "降" => "降段",
        "次" => "次点",
        ""   => "none",
      }.fetch(key, key)
    end
  end
end
