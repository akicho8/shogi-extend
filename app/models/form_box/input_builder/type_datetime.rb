module FormBox
  module InputBuilder
    class TypeDatetime < TypeString
      def default_right_width
        3
      end

      def input_tag
        :datetime_local_field_tag
      end

      def default
        if s = super.presence
          time = Time.zone.parse(s.to_s)
          if params[:second_skip]
            # 12:34:56 のとき 56 が入力できずにうっすら残るため 12:34:00 にする
            time = time.beginning_of_minute
          end
          time.strftime("%Y-%m-%dT%T") # Rails側が不親切なので自力でフォーマットを合わせてないといけない
        end
      end

      def html_options
        if v = step
          super.merge(:step => v)
        else
          super
        end
      end

      def step
        unless params[:second_skip]
          params[:datetime_step] || 1 # 秒まで入力。60 なら秒省略
        end
      end
    end
  end
end
