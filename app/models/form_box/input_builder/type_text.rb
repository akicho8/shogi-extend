module FormBox
  module InputBuilder
    class TypeText < Base
      def tag_build
        h.text_area_tag(key, default, form_controll)
      end

      def rows
        if params[:as_small_as_possible] # 「なるべく小さく」オプション
          [default.to_s.lines.size, 1].max
        else
          if default.blank?
            v = params[:rows] || 4
          else
            v = default.to_s.lines.size
          end
          [v, (params[:min_rows] || 4)].max
        end
      end

      def form_controll
        super.merge({
            :cols  => nil,
            :rows  => rows,
            :class => "textarea",
          })
      end
    end
  end
end
