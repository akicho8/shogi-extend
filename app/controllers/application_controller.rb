class ApplicationController < ActionController::Base
  add_flash_types :success, :info, :warning, :danger

  def submitted?(name)
    [name, "#{name}.x", "#{name}.y"].any? {|e| params.key?(e) }
  end
  helper_method :submitted?

  private

  def h
    @h ||= view_context
  end
  delegate :tag, :link_to, :icon_tag, to: :h

  concerning :BotCheckMethods do
    included do
      helper_method :bot_agent?
    end

    class_methods do
      def bot_regexp
        # ▼HTTP_USER_AGENTでbot,Browser,Deviceチェック - Qiita
        # https://qiita.com/haco99/items/c8321b2992080364d08c
        @bot_regexp ||= Regexp.union("Googlebot", "Yahoo! Slurp", "Mediapartners-Google", "msnbot", "bingbot", "MJ12bot", "Ezooms", "pirst; MSIE 8.0;", "Google Web Preview", "ia_archiver", "Sogou web spider", "Googlebot-Mobile", "AhrefsBot", "YandexBot", "Purebot", "Baiduspider", "UnwindFetchor", "TweetmemeBot", "MetaURI", "PaperLiBot", "Showyoubot", "JS-Kit", "PostRank", "Crowsnest", "PycURL", "bitlybot", "Hatena", "facebookexternalhit")
      end
    end

    def bot_agent?
      request.user_agent.to_s.match?(self.class.bot_regexp)
    end
  end
end
