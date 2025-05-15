module Swars
  module Agent
    class Record < Base
      def fetch
        if params[:verbose]
          puts "[fetch][record] #{key.official_url}"
        end
        html = fetcher.fetch(:record, key.official_url)
        if !html || params[:BattleNotFound]
          raise BattleNotFound.new("指定の対局が存在しません<br>URLを間違えていませんか？<br>#{key.official_url}<br>それか将棋ウォーズ本家がメンテナンス中かもしれません")
        end
        md = html.match(/data-react-props="(.*?)"/)
        if !md || params[:SwarsFormatIncompatible]
          raise SwarsFormatIncompatible
        end
        JSON.parse(CGI.unescapeHTML(md.captures.first))
      end

      private

      def key
        params.fetch(:key)
      end
    end
  end
end
