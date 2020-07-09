module FormBox
  module InputBuilder
    class TypeInteger < TypeString
      def input_tag
        :number_field_tag
      end
    end
  end
end
