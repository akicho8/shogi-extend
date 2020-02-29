module FormBox
  module InputBuilder
    class TypeSelect < Base
      def tag_build
        h.select_tag(key, h.send(method_for_select, params[:elems], default), form_controll)
      end

      def method_for_select
        :options_for_select
      end

      # prompt は面倒なので使わない。include_blank はずっと表示される
      def form_controll
        super.merge(params.slice(:include_blank, :multiple))
      end
    end
  end
end
