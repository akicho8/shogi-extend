module FormBox
  module InputBuilder
    class << self
      def input_render(params)
        if params[:type].kind_of?(Class)
          model = params[:type]
        else
          model = "#{name}::Type#{params[:type].to_s.classify}".constantize
        end
        model.new(params).input_render
      end
    end

    TypeFloat = TypeString
    TypeSymbol = TypeString

    class TypeEmail < TypeString
      def input_tag
        :email_field_tag
      end
    end

    class TypeUrl < TypeString
      def input_tag
        :url_field_tag
      end
    end

    class TypeInteger < TypeString
      def input_tag
        :number_field_tag
      end
    end

    class TypePassword < TypeString
      def input_tag
        :password_field_tag
      end
    end

    class TypeNestedSelect < TypeSelect
      def method_for_select
        :grouped_options_for_select
      end
    end
  end
end
