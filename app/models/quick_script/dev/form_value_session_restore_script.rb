module QuickScript
  module Dev
    class FormValueSessionRestoreScript < Base
      self.title = "フォーム値を保存する"
      self.description = "フォーム値を保存するテスト (元々 session に保存していたのは設計ミスで、現在は session_id をキーにして DB に保存している)"
      self.form_method = :get

      def form_parts
        super + [
          {
            :label        => "str1",
            :key          => :str1,
            :type         => :string,
            :session_sync => true,
            :dynamic_part => -> {
              {
                :default => params[:str1].presence || "(str1)",
              }
            },
          },
          {
            :label        => "radio1",
            :key          => :radio1,
            :type         => :radio_button,
            :session_sync => true,
            :dynamic_part => -> {
              {
                :elems        => ["a", "b", "c"],
                :default => params[:radio1].presence || "a",
              }
            },
          },
        ]
      end

      def call
        PermanentVariable.order(created_at: :desc).limit(100)
      end
    end
  end
end
