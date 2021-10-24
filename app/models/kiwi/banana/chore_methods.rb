module Kiwi
  class Banana
    concern :ChoreMethods do
      def og_meta
        {
          :title       => [title, user.name].compact.join(" - "),
          :description => description.to_s,
          :og_image    => lemon.og_image_path,
          :og_video    => lemon.og_video_path,
        }
      end

      def tweet_body
        list = [title, *tag_list, "将棋動画"]
        list.collect { |e| "#" + e.gsub(/[\p{blank}-]+/, "_") }.join(" ")
      end

      # サムネイル再作成
      # rails r 'Kiwi::Banana.find_each(&:thumbnail_rebuild)'
      # cap staging rails:runner CODE='Kiwi::Banana.find_each(&:thumbnail_rebuild)'
      # cap production rails:runner CODE='Kiwi::Banana.find_each(&:thumbnail_rebuild)'
      def thumbnail_rebuild
        if lemon
          lemon.thumbnail_build(thumbnail_pos)
        end
      end

      def page_url(options = {})
        UrlProxy.full_url_for("/video/watch/#{key}")
      end
    end
  end
end
