module FormBox
  module InputBuilder
    class TypeNestedSelect < TypeSelect
      def method_for_select
        :grouped_options_for_select
      end
    end
  end
end
