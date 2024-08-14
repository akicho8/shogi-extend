module QuickScript
  module Dev
    class FormValueSessionRestoreScript < Base
      self.title = "フォーム値をブラウザに保存する"
      self.description = "Rails 側の session を使ってフォーム値を保存するテスト"
      self.form_method = :get

      def form_parts
        super + [
          {
            :label   => "str1",
            :key     => :str1,
            :type    => :string,
            :default => params[:str1].presence || "(string)",
          },
          {
            :label   => "radio1",
            :key     => :radio1,
            :type    => :radio_button,
            :elems   => ["a", "b", "c"],
            :default => params[:radio1].presence || "a",
          },
        ]
      end

      def call
        params_restore_and_save_from_session(:str1, :radio1)
        session
      end
    end
  end
end
