module QuickScript
  module Dev
    class FormScript < Base
      self.title = "form"
      self.description = "form_parts のテスト"
      self.form_method = :get

      def form_parts
        super + [
          {
            :label   => "string",
            :key     => :str1,
            :type    => :string,
            :default => params[:str1].presence || "(string)",
          },
          {
            :label   => "text",
            :key     => :text1,
            :type    => :text,
            :default => params[:text1].presence || "(text)",
          },
          {
            :label   => "integer",
            :key     => :int1,
            :type    => :integer,
            :default => (params[:int1].presence || "1").to_i,
          },
          {
            :label   => "select (array)",
            :key     => :select1,
            :type    => :select,
            :elems   => ["a", "b", "c"],
            :default => params[:select1].presence || "a",
          },
          {
            :label   => "select (hash)",
            :key     => :select2,
            :type    => :select,
            :elems   => {"選択1" => "a", "選択2" => "b", "選択3" => "c"},
            :default => params[:select2].presence || "a",
          },
          {
            :label   => "radio (array)",
            :key     => :radio1,
            :type    => :radio_button,
            :elems   => ["a", "b", "c"],
            :default => params[:radio1].presence || "a",
          },
          {
            :label   => "radio (hash)",
            :key     => :radio2,
            :type    => :radio_button,
            :elems   => {"選択1" => "a", "選択2" => "b", "選択3" => "c"},
            :default => params[:radio2].presence || "a",
          },
          {
            :label   => "checkbox (array)",
            :key     => :checkbox1,
            :type    => :checkbox_button,
            :elems   => ["a", "b", "c"],
            :default => Array(params[:checkbox1].presence || "a"),
          },
        ]
      end

      def call
        params
      end
    end
  end
end
