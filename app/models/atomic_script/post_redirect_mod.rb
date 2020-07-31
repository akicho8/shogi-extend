module AtomicScript
  concern :PostRedirectMod do
    def put_action
      resp = script_body_run
      if c.performed?
        return
      end

      # エラーだったらリダイレクトせずに描画する
      if resp[:error]
        c.render :html => response_render(resp), layout: true
        return
      end

      if store_to_cookie_flash?
        h.flash[_store_key] = resp
      else
        Rails.cache.write(_store_key, resp, expires_in: 1.minutes)
      end
      c.redirect_to [*url_prefix, clean_params.merge(_restore_key: _store_key)]
    end

    private

    def to_body_html
      restored_response
    end

    def clean_params
      params.except(:controller, :action, :_method, :authenticity_token, :_submit, :id)
    end

    def form_enable?
      true
    end

    def buttun_name
      "本当に実行する"
    end

    def form_submit_button_color
      "is-danger"
    end

    def form_action_method
      :put
    end

    def _store_key
      @_store_key ||= SecureRandom.hex
    end

    def restored_response
      if v = @params[:_restore_key]
        if store_to_cookie_flash?
          if v = h.flash[v]
            v.symbolize_keys # Cookieはシンボルを文字列にしてしまうため復元時に戻す
          end
        else
          Rails.cache.read(v)
        end
      end
    end

    def redirected?
      @params[:_restore_key].present?
    end

    # Cookie が溢れるときは rails dev:cache で ON にする
    def store_to_cookie_flash?
      Rails.cache.kind_of?(ActiveSupport::Cache::NullStore)
    end
  end
end
