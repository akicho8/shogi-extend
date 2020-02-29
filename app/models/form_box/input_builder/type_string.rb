module FormBox
  module InputBuilder
    class TypeString < Base
      def input_tag
        :text_field_tag
      end

      def tag_build
        h.send(input_tag, key, default, form_controll)
      end
    end
  end
end
