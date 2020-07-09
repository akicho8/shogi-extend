module FormBox
  module InputBuilder
    class TypePassword < TypeString
      def input_tag
        :password_field_tag
      end
    end
  end
end
