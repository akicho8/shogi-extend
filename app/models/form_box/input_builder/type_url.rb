module FormBox
  module InputBuilder
    class TypeUrl < TypeString
      def input_tag
        :url_field_tag
      end
    end
  end
end
