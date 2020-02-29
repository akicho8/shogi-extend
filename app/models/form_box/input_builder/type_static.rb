module FormBox
  module InputBuilder
    class TypeStatic < Base
      def tag_build
        h.content_tag(:p, default, form_controll.merge(:class => "form-control-static"))
      end
    end
  end
end
