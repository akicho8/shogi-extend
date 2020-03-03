module AtomicScript
  concern :PostMod do
    def put_action
      resp = script_body_run
      if c.performed?
        # script_body の中ですでにリダイレクトしていればそれを優先してこちらでは何もしない
        return
      end

      # エラーだったらリダイレクトせずに描画する
      if resp[:error_message]
        c.render :text => response_render(Response[resp]), :layout => true
        return
      end

      Rails.cache.write(_restore_key, resp, expires_in: 1.minutes)
      c.redirect_to [*url_prefix, clean_params.merge(_restore_key: _store_key)]
    end

    private

    def to_body_html
      # POSTの場合は結果だけを表示する場合
      v = restore_resp
      if v
        v = Response[v]
      end
      return v
    end

    def post_redirect_path(redirect_params)
    end

    def clean_params
      params.except(:controller, :action, :_method, :authenticity_token, :_submit, :id)
    end

    def form_render?
      true
    end

    def buttun_name
      "本当に実行する"
    end

    def form_submit_button_color
      'is-danger'
    end

    def form_action_method
      :put
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
