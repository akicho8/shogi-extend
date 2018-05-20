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

  concerning :CurrentChatUserMethods do
    included do
      helper_method :current_chat_user

      before_action do
        current_chat_user

        @js_global_params = {
          current_chat_user: current_chat_user,
          online_only_count: ChatUser.online_only.count,
          fighter_only_count: ChatUser.fighter_only.count,
          lifetime_infos: LifetimeInfo.as_json,
        }
      end
    end

    class_methods do
    end

    def current_chat_user
      @current_chat_user ||= ChatUser.find_by(id: cookies.signed[:chat_user_id])
      @current_chat_user ||= ChatUser.create!
      cookies.signed[:chat_user_id] = {value: @current_chat_user.id, expires: 1.weeks.from_now}
      @current_chat_user
    end
  end
end
