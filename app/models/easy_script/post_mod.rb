module EasyScript
  concern :PostMod do
    included do
      # POSTでフォームを送信するか？
      class_attribute :post_method_use_p
      self.post_method_use_p = false
    end

    # POST
    def put_action
      # code = run_and_result_cache_write # ここで実行している

      retv = script_body_run

      # script_body の中ですでにリダイレクトしていればそれを優先してこちらでは何もしない
      if c.performed?
        return
      end

      if true
        # エラーだったらリダイレクトせずに描画する
        if retv[:alert_message]
          c.render :text => response_render(Response[retv]), :layout => true
          return
        end
      end

      as_rails_cache_store_key = SecureRandom.hex
      # POST で User.all.to_a などを返すと AR の配列が Marshal.dump されて undefined class/module な現象が起きる。
      # これはmemcachedへのMarshalの不具合。
      #
      # undefined class/module とか言われてアプリの起動ができなくなってしまう
      # http://xibbar.hatenablog.com/entry/20130221/1361556846
      #
      Rails.cache.write(as_rails_cache_store_key, retv, :expires_in => 3.minutes)

      redirect_params = clean_params
      redirect_params[:as_rails_cache_store_key] = as_rails_cache_store_key
      # _resp = Rails.cache.read(code)

      if false
        # エラーだったら同じとこにリダイレクトする
        if retv[:alert_message]
          c.redirect_to [*url_prefix, redirect_params]
          return
        end
      end

      # id は入っていないがなぜか補完される
      url = post_redirect_path(redirect_params)

      c.redirect_to url
    end

    # def put_action
    #   retv = script_body_run
    #
    #   # script_body の中ですでにリダイレクトしていればそれを優先してこちらでは何もしない
    #   if c.performed?
    #     return
    #   end
    #
    #   # POST で User.all.to_a などを返すと AR の配列が Marshal.dump されて undefined class/module な現象が起きる。
    #   # これはmemcachedへのMarshalの不具合。
    #   #
    #   # undefined class/module とか言われてアプリの起動ができなくなってしまう
    #   # http://xibbar.hatenablog.com/entry/20130221/1361556846
    #   #
    #   as_rails_cache_store_key = SecureRandom.hex
    #   Rails.cache.write(as_rails_cache_store_key, retv, :expires_in => 3.minutes)
    #
    #   c.redirect_to post_redirect_path(clean_params.merge(:as_rails_cache_store_key => as_rails_cache_store_key))
    # end

    # def url_prefix
    #   self.class.url_prefix
    # end

    private

    def to_body_html
      # POSTの場合は結果だけを表示する場合
      if post_method_use_p
        v = cached_result
        if v
          v = Response[v]
        end
        return v
      end

      # # これだと submit? してないときに script_body を実行する(危険)
      # if redirected?
      #   v = cached_result
      #   if v
      #     v = Response[v]
      #   end
      #   return v
      # end

      super
    end

    def post_redirect_path(redirect_params)
      [*url_prefix, redirect_params]
    end

    def clean_params
      params.except(:controller, :action, :_method, :authenticity_token, :_submit, :id)
    end

    def form_render?
      if post_method_use_p
        true
      else
        super
      end
    end

    def buttun_label
      if post_method_use_p
        post_buttun_label
      else
        super
      end
    end

    def form_submit_button_color
      if post_method_use_p
        'is-danger'
      else
        super
      end
    end

    def post_buttun_label
      "本当に実行する"
    end

    def form_action_method
      if post_method_use_p
        :put
      else
        super
      end
    end
  end
end
