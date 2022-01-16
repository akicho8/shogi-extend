module Wkbk
  class Article
    concern :InfoMethods do
      def info
        {
          "ID"         => id,
          "KEY"        => key,
          "タイトル"   => title,
          "投稿者"     => user.name,
          "公開設定"   => folder.name,
          "URL"        => page_url,
          "種類"       => lineage.name,
          "難易度"     => difficulty,
          "メッセージ" => direction_message,
          "タグ"       => tag_list.join(", "),
          "説明"       => description.presence.to_s.squish,
        }
      end

      # ZIPにするとき用
      def to_kif
        header = info.collect { |k, v| "問題#{k}：#{v}\n" }.join

        str = Transform.to_kif_from(main_sfen)
        str = str.gsub(/^.*の備考.*\n/, "")
        str = str.gsub(/^まで.*\n/, "")

        header + str
      end

      def page_url(options = {})
        path = ["/rack/articles/#{key}", options.to_query].find_all(&:present?).join("?")
        UrlProxy.full_url_for(path)
      end

      def share_board_png_url
        Rails.application.routes.url_helpers.url_for([:share_board, {only_path: false, format: "png", **share_board_params}])
      end

      def share_board_path(params = {})
        "/share-board?#{share_board_params.merge(params).to_query}"
      end

      def share_board_url
        UrlProxy.full_url_for(share_board_path(title: title))
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
