module FormBox
  module InputBuilder
    class TypeEmail < TypeString
      def input_tag
        :email_field_tag
      end
    end
  end
end
