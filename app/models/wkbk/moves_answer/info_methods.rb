module Wkbk
  class MovesAnswer
    concern :InfoMethods do
      def info
        article.info.merge({
                             "正解ID"         => id,
                             "正解番号"       => position.next,
                             "正解手数"       => moves_count,
                             "人間向けの解答" => moves_human_str,
                             "正解作成日時"   => created_at.to_s(:ymdhm),
                             "*画像URL"       => share_board_png_url,
                             "*共有将棋盤URL" => share_board_url,
                           })
      end

      def full_sfen
        "#{article.init_sfen} moves #{moves_str}"
      end

      def to_kif_header
        info.collect { |k, v| "#{k}：#{v}\n" }.join
      end

      def to_kif
        to_kif_header + parser.to_kif
      end

      private

      def share_board_png_url
        Rails.application.routes.url_helpers.url_for([:share_board, {only_path: false, format: "png", **share_board_params}])
      end

      def share_board_url
        Rails.application.routes.url_helpers.url_for([:share_board, {only_path: false, title: article.title, **share_board_params}])
      end

      def share_board_params
        { body: full_sfen, turn: 0, abstract_viewpoint: article.viewpoint }
      end
    end
  end
end
