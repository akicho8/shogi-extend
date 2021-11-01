module Wkbk
  class Article
    concern :InfoMethods do
      def info
        {
          "問題ID"         => id,
          "問題KEY"        => key,
          "問題タイトル"   => title,
          "問題投稿者"     => user.name,
          "問題公開設定"   => folder.name,
          "*問題URL"       => page_url,
          "問題種類"       => lineage.name,
          "問題難易度"     => difficulty,
          "問題メッセージ" => direction_message,
          "問題タグ"       => tag_list.join(", "),
          "問題説明"       => description.presence.to_s.squish,
        }
      end

      def to_kif
        str = Transform.to_kif_from(main_sfen)
        str = str.gsub(/^.*の備考.*\n/, "")
        str = str.gsub(/^まで.*\n/, "")

        info.collect { |k, v| "#{k}：#{v}\n" }.join + str
      end

      def page_url(options = {})
        UrlProxy.full_url_for("/rack/articles/#{key}")
      end

      def share_board_png_url
        Rails.application.routes.url_helpers.url_for([:share_board, {only_path: false, format: "png", **share_board_params}])
      end

      def share_board_url
        Rails.application.routes.url_helpers.url_for([:share_board, {only_path: false, title: title, **share_board_params}])
      end

      def share_board_params
        { body: main_sfen, turn: 0, abstract_viewpoint: viewpoint }
      end

      # Twitter画像が表示できる url_for にそのまま渡すパラメータ
      def shared_image_params
        [:share_board, body: main_sfen, only_path: false, format: "png", turn: 0, abstract_viewpoint: viewpoint]
      end

      # 配置 + 1問目
      def main_sfen
        if moves_answers.blank?
          init_sfen
        else
          "#{init_sfen} moves #{moves_answers.first.moves_str}"
        end
      end

      # def main_moves_human_str
      #   if e = moves_answers.first
      #     e.moves_human_str
      #   end
      # end

      def tweet_body
        out = []
        out << title
        if direction_message.present?
          out << direction_message
        end
        if description.present?
          out << description
        end
        moves_answers.each.with_index(1) do |e, i|
          out << "#{i}. #{e.moves_human_str}"
        end
        out << tweet_tag_part
        out.join("\n")
      end

      private

      def tweet_tag_part
        [*tag_list, "インスタント将棋問題集"].collect { |e|
          "#" + e.gsub(/[\p{blank}-]+/, "_")
        }.join(" ")
      end
    end
  end
end
