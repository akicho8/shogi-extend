module QuickScript
  module Dev
    class FormBuefyTaginputScript < Base
      self.title = "複数タグ補完入力"
      self.description = "複数タグ補完入力のテスト"
      self.form_method = :get

      def form_parts
        super + [
          {
            :label        => "複数タグ入力",
            :key          => :ary1,
            :type         => :b_taginput,
            :dynamic_part => -> {
              {
                # :auto_complete_feature => true,
                :elems   => ["foo", "bar", "baz"],
                :default => Array(params[:ary1]),
              }
            },
          },
        ]
      end

      def call
        params
      end
    end
  end
end
