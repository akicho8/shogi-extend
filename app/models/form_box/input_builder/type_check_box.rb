module FormBox
  module InputBuilder
    class TypeCheckBox < Base
      def tag_build
        # ハッシュの場合は "文字" => 1 だけど配列の場合は [1, nil] だけになるので [1, 1] の状態にする
        elsms = params[:elems].collect {|k, v| [k.to_s, (v || k).to_s]}
        elsms.collect {|right_label, v|
          h.content_tag(:label, :class => "checkbox-inline") do
            checked = default.include?(v.to_s)
            h.check_box_tag("#{key}[]", v, checked, :disabled => params[:freeze]) + right_label
          end
        }.join.html_safe
      end

      def default
        v = super
        if v.respond_to?(:to_a)
          v = v.to_a
        else
          v = Array.wrap(v)
        end
        v.collect(&:to_s)
      end
    end
  end
end
