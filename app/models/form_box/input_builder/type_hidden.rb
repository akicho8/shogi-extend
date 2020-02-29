module FormBox
  module InputBuilder
    class TypeHidden < Base
      def input_render
        if default.kind_of?(Array)
          default.collect { |e| h.hidden_field_tag("#{key}[]", e) }
        else
          h.hidden_field_tag(key, default)
        end
      end
    end
  end
end
