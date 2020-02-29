module FormBox
  module InputBuilder
    class TypeRadio < Base
      def label_build
        h.content_tag(:label, i18n_label_with_tooltip, label_html_options)
      end

      def tag_build
        # ハッシュの場合は "文字" => 1 だけど配列の場合は [1, nil] だけになるので [1, 1] の状態にする
        elsms = params[:elems].collect {|k, v| [k.to_s, (v || k).to_s]}
        elsms.collect {|right_label, v|
          h.content_tag(:label, :class => "radio-inline") do
            checked = (v.to_s == default.to_s)
            h.radio_button_tag("#{key}[#{right_label}]", v, checked, {:name => key}.merge(html_options)) + right_label
          end
        }.join.html_safe
      end
    end
  end
end
