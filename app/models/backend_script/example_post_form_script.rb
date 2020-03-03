#
# フォームなし
#
# http://localhost:3000/admin/scripts/example_post_form_page
module BackendScript
  class ExamplePostFormScript < ::BackendScript::Base
    include AtomicScript::PostMod

    self.category = "スクリプト例"
    self.script_name = "POSTフォーム"

    def form_parts
      {
        :label   => "値",
        :key     => :foo,
        :type    => :string,
        :default => params[:foo],
      }
    end

    def script_body
      if submitted?
        # POST実行時
        params
      else
        return "動かないときは rails dev:cache すること"

        hex = SecureRandom.hex
        val = SecureRandom.hex
        Rails.cache.write(hex, val, :expires_in => 1.minutes)
        if Rails.cache.read(hex) == val
          "キャッシュ有効"
        else
          "キャッシュ無効"
        end
      end
    end
  end
end
