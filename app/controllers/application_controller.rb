class ApplicationController < ActionController::Base
  extend Lettable

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
      add_flash_types :success, :info, :warning, :danger
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

  concerning :CurrentUserMethods do
    included do
      let :js_global_params do
        {
          :current_user        => current_user && ams_sr(current_user, serializer: Fanta::CurrentUserSerializer),
          :online_only_count   => Fanta::User.online_only.count,
          :fighter_only_count  => Fanta::User.fighter_only.count,
          :lifetime_infos      => Fanta::LifetimeInfo,
          :team_infos          => Fanta::TeamInfo,
          :custom_preset_infos => Fanta::CustomPresetInfo,
          :robot_accept_infos  => Fanta::RobotAcceptInfo,
          :last_action_infos   => Fanta::LastActionInfo,
        }
      end

      let :current_user do
        unless bot_agent?
          user_id = nil
          unless Rails.env.production?
            user_id ||= params[:__user_id__]
          end
          user_id ||= cookies.signed[:user_id]

          user ||= Fanta::User.find_by(id: user_id)

          if Rails.env.test?
            unless user
              user = Fanta::User.create!(name: params[:__user_name__], user_agent: request.user_agent)
              current_user_set_id(user.id)
            end
          end

          user
        end
      end
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
      return if Rails.env.production?
      out = []
      out << tag.div(:class => "buttons") do
        [
          link_to_eval("ユーザーセットアップ") { "Fanta::User.setup" },
          link_to_eval("ユーザー全削除") { "Fanta::User.destroy_all" },
          link_to_eval("ユーザー追加") { "Fanta::User.create!" },
          link_to_eval("1 + 2") { "1 + 2" },
          link_to_eval("1 / 0", redirect_to: root_path) { "1 / 0" },
          link_to_eval("find(0)", redirect_to: root_path) { "Fanta::User.find(0)" },
          link_to_eval("部屋作成") { "Fanta::Battle.create!" },
          link_to_eval("部屋削除") { "Fanta::Battle.last&.destroy!" },
          link_to_eval("部屋全削除") { "Fanta::Battle.destroy_all" },
        ].compact.join.html_safe
      end

      list = Fanta::User.all.collect do |e|
        {}.tap do |row|
          row[:id] = link_to(e.id, e)
          row[:name] = link_to(e.name, e)
          row["操作"] = [
            link_to_eval("login") { "current_user_set_id(#{e.id})" },
            link_to_eval("削除") { "Fanta::User.find(#{e.id}).destroy!" },
            link_to_eval("online") { "Fanta::User.find(#{e.id}).update!(online_at: Time.current)" if !e.online_at },
            link_to_eval("offline") { "Fanta::User.find(#{e.id}).update!(online_at: nil)" if e.online_at },
            link_to_eval("logout") { "reset_session" if e == current_user },
            link_to_eval("名前変更") { "Fanta::User.find(#{e.id}).update!(name: SecureRandom.hex)" },
          ].compact.join(" ").html_safe
        end
      end
      out << list.to_html

      tag.br + out.join.html_safe
    end
  end
end
