class ApplicationController < ActionController::Base
  extend Lettable

  before_action do
    if params[:__redirect_to]
      redirect_to params[:__redirect_to], params.permit![:__flash]
    end
  end

  concerning :ActiveModelSerializerMethods do
    included do
      # 効かないのはなぜ……？
      #
      # ▼active_model_serializers/serializers.md at v0.10.6 · rails-api/active_model_serializers
      # https://github.com/rails-api/active_model_serializers/blob/v0.10.6/docs/general/serializers.md
      #
      # serialization_scope :view_context
    end
  end

  concerning :Choremethods do
    included do
      add_flash_types *FlashInfo.flash_all_keys
      helper_method :submitted?
    end

    def submitted?(name)
      params.key?(name)
    end

    private

    def h
      @h ||= view_context
    end
    delegate :tag, :link_to, :icon_tag, to: :h
  end

  concerning :CurrentUserMethods do
    included do
      let :js_global do
        {
          :current_user        => current_user && ams_sr(current_user, serializer: Colosseum::CurrentUserSerializer),
          :online_only_count   => Colosseum::User.online_only.count,
          :fighter_only_count  => Colosseum::User.fighter_only.count,
          :lifetime_infos      => Colosseum::LifetimeInfo,
          :team_infos          => Colosseum::TeamInfo,
          :custom_preset_infos => Colosseum::CustomPresetInfo,
          :robot_accept_infos  => Colosseum::RobotAcceptInfo,
          :last_action_infos   => Colosseum::LastActionInfo,
          :login_path          => url_for([:xuser_session, __redirect_to: url_for(:xuser_session), __flash: {alert: "アカウント登録もしくはログインしてください。すぐに遊びたい場合は「即席アカウントを作成してログイン」を使ってみてください。"}]),
        }
      end

      let :sysop? do
        current_user && current_user.sysop?
      end

      helper_method :current_user
    end

    def current_user
      @current_user ||= -> {
        # # unless bot_agent?       # ブロックの中なので guard return してはいけない
        # user_id = nil
        # # unless Rails.env.production?
        # #   user_id ||= params[:__user_id__]
        # # end
        # user_id ||=

        user ||= Colosseum::User.find_by(id: cookies.signed[:user_id])
        user ||= current_xuser

        if Rails.env.test?
          if params[:__create_user_name__]
            user ||= Colosseum::User.create!(name: params[:__create_user_name__], user_agent: request.user_agent)
          end
        end

        if user
          cookies.signed[:user_id] = {value: user.id, expires: 1.years.from_now}
        end

        user
        # end
      }.call
    end

    def current_user_set_id(user_id)
      if instance_variable_defined?(:@current_user)
        remove_instance_variable(:@current_user)
      end
      if user_id
        cookies.signed[:user_id] = {value: user_id, expires: 1.years.from_now}
      else
        cookies.delete(:user_id)
      end
    end

    def current_user_logout
      current_user_set_id(nil)
      sign_out(:xuser)
    end
  end

  concerning :EvalMethods do
    def link_to_eval(name, options = {}, &block)
      if code = block.call
        link_to(name, eval_path(options.merge(code: code)), method: :put, :class => "button is-small")
      end
    end

    def eval_box
      return unless Rails.env.development?

      out = []
      out << tag.div(:class => "buttons") do
        [
          link_to_eval("ユーザーセットアップ") { "Colosseum::User.setup" },
          link_to_eval("ユーザー全削除") { "Colosseum::User.destroy_all" },
          link_to_eval("ユーザー追加") { "Colosseum::User.create!" },
          link_to_eval("1 + 2") { "1 + 2" },
          link_to_eval("1 / 0", redirect_to: root_path) { "1 / 0" },
          link_to_eval("find(0)", redirect_to: root_path) { "Colosseum::User.find(0)" },
          link_to_eval("部屋作成") { "Colosseum::Battle.create!" },
          link_to_eval("部屋削除") { "Colosseum::Battle.last&.destroy!" },
          link_to_eval("部屋全削除") { "Colosseum::Battle.destroy_all" },
          link_to_eval("flash確認", redirect_to: root_path(debug: "true")) { "" },
        ].compact.join.html_safe
      end

      list = Colosseum::User.all.collect do |e|
        {}.tap do |row|
          row[:id] = link_to(e.id, e)
          row[:name] = link_to(e.name, e)
          row["操作"] = [
            link_to_eval("login") { "current_user_set_id(#{e.id})" },
            link_to_eval("削除") { "Colosseum::User.find(#{e.id}).destroy!" },
            link_to_eval("online") { "Colosseum::User.find(#{e.id}).update!(online_at: Time.current)" if !e.online_at },
            link_to_eval("offline") { "Colosseum::User.find(#{e.id}).update!(online_at: nil)" if e.online_at },
            link_to_eval("logout") { "reset_session" if e == current_user },
            link_to_eval("名前変更") { "Colosseum::User.find(#{e.id}).update!(name: SecureRandom.hex)" },
          ].compact.join(" ").html_safe
        end
      end
      out << list.to_html

      tag.br + out.join.html_safe
    end
  end

  concerning :BotCheckMethods do
    included do
      let :bot_agent? do
        request.user_agent.to_s.match?(self.class.bot_regexp)
      end
    end

    class_methods do
      def bot_regexp
        # ▼HTTP_USER_AGENTでbot,Browser,Deviceチェック - Qiita
        # https://qiita.com/haco99/items/c8321b2992080364d08c
        @bot_regexp ||= Regexp.union(*[
            "Googlebot",
            "Yahoo! Slurp",
            "Mediapartners-Google",
            "msnbot",
            "bingbot",
            "MJ12bot",
            "Ezooms",
            "pirst; MSIE 8.0;",
            "Google Web Preview",
            "ia_archiver",
            "Sogou web spider",
            "Googlebot-Mobile",
            "AhrefsBot",
            "YandexBot",
            "Purebot",
            "Baiduspider",
            "UnwindFetchor",
            "TweetmemeBot",
            "MetaURI",
            "PaperLiBot",
            "Showyoubot",
            "JS-Kit",
            "PostRank",
            "Crowsnest",
            "PycURL",
            "bitlybot",
            "Hatena",
            "facebookexternalhit",
          ])
      end
    end
  end
end
