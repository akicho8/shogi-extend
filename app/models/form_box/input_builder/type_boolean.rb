module FormBox
  module InputBuilder
    # Bootstrap3 では、ラベルの横になにもないと、チェックボックスが下にズレるので、&nbsp; を入れている
    # 使うときは elems は指定しない方がいい。elems を独自に指定すると一気にコードが読みににくくなる
    # 独自に指定するぐらいなら checkbox を使った方がいい
    class TypeBoolean < Base
      def tag_build
        if params[:elems]
          raise "elems を独自に指定するんなら checkbox を使った方がいい"
        end

        _for = key
        h.content_tag(:label, :class => "checkbox-inline", :for => _for) do
          elsms = params[:elems] || ["true", "false"]
          checked = (elsms.first.to_s == default.to_s)

          s = "".html_safe
          if !params[:freeze]
            s << h.hidden_field_tag(key, elsms.last, :id => nil) # 非チェック時に偽を返すための技
          end
          s << h.check_box_tag(key, elsms.first, checked, :id => _for, :disabled => params[:freeze]) + right_label
        end
      end

      def right_label
        s = params[:right_label] || "有効にする"
        s = s.presence || "&nbsp;" # 何かないと Bootstrap3 でズレるため
        s.html_safe
      end
    end
  end
end
