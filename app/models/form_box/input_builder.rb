module FormBox
  module InputBuilder
    TypeFloat = TypeString
    TypeSymbol = TypeString

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
  end
end
