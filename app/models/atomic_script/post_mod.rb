module AtomicScript
  concern :PostMod do
    included do
      # POSTでフォームを送信するか？
      class_attribute :post_method_use_p
      self.post_method_use_p = false
    end

    # POST
    def put_action
      resp = script_body_run

      # script_body の中ですでにリダイレクトしていればそれを優先してこちらでは何もしない
      if c.performed?
        return
      end

      if true
        # エラーだったらリダイレクトせずに描画する
        if resp[:error_message]
          c.render :text => response_render(Response[resp]), :layout => true
          return
        end
      end

      Rails.cache.write(_restore_key, resp, expires_in: 1.minutes)

      redirect_params = clean_params
      redirect_params[:_restore_key] = _store_key

      # id は入っていないがなぜか補完される
      url = post_redirect_path(redirect_params)

      c.redirect_to url
    end

    private

    def to_body_html
      # POSTの場合は結果だけを表示する場合
      if post_method_use_p
        v = restore_resp
        if v
          v = Response[v]
        end
        return v
      end

      # # これだと submit? してないときに script_body を実行する(危険)
      # if redirected?
      #   v = restore_resp
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

    def buttun_name
      if post_method_use_p
        post_buttun_name
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

    def post_buttun_name
      "本当に実行する"
    end

    def form_action_method
      if post_method_use_p
        :put
      else
        super
      end
    end

    def _store_key
      @_store_key ||= SecureRandom.hex
    end

    def restore_resp
      if v = @params[:_restore_key]
        Rails.cache.read(v)
      end
    end

    def redirected?
      @params[:_restore_key].present?
    end

  end
end
