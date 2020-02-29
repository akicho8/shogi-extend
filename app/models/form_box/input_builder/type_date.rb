module FormBox
  module InputBuilder
    class TypeDate < TypeString
      def input_tag
        :date_field_tag
      end

      def default
        if s = super.presence
          Time.zone.parse(s.to_s).strftime("%Y-%m-%d") # Rails側が不親切なので自力でフォーマットを合わせてないといけない
        end
      end
    end
  end
end
