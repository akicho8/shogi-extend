module QuickScript
  module Tool
    class ShortUrlScript < Base
      self.title = "短縮URL化"
      self.description = "このサイトのURLを短かくする"
      self.form_method = :post

      def form_parts
        super + [
          {
            :label   => "長いURL",
            :key     => :original_url,
            :type    => :string,
            :dynamic_part => -> {
              {
                :default => current_original_url,
              }
            },
          },
        ]
      end

      def call
        unless request_post?
          return
        end
        if current_original_url.blank?
          return
        end
        validate!
        if flash.present?
          return
        end
        flash[:notice] = "変換しました"
        { _autolink: ShortUrl[current_original_url] }
      end

      def validate!
        unless current_original_url.match?(URI.regexp(["https", "http"]))
          flash[:notice] = "正しいURLを入力しよう"
          return
        end
        unless current_original_url.start_with?(ShortUrl::Component.root_url)
          flash[:notice] = "それは他のサイトです"
          return
        end
      end

      def current_original_url
        params[:original_url].to_s.strip
      end
    end
  end
end
