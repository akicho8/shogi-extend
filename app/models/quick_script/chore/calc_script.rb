module QuickScript
  module Chore
    class CalcScript < Base
      self.title = "計算機"

      def call
        current_lhv.public_send(current_operator, current_rhv)
      end

      private

      # ~/src/shogi-extend/nuxt_side/components/QuickScript/QuickScriptShow.vue
      def form_parts
        super + [
          {
            :label   => "左辺",
            :key     => :lhv,
            :type    => :integer,
            :default => params[:lhv].presence.try { to_i } || 1,
          },
          {
            :label   => "演算子",
            :key     => :operator,
            :type    => :select,
            :elems   => ["+", "-"],
            :default => current_operator,
          },
          {
            :label   => "右辺",
            :key     => :rhv,
            :type    => :integer,
            :default => params[:rhv].presence.try { to_i } || 2,
          },
        ]
      end

      def get_button
        true
      end

      def button_label
        "実行"
      end

      def current_lhv
        params[:lhv].to_i
      end

      def current_rhv
        params[:rhv].to_i
      end

      def current_operator
        params[:operator] || "+"
      end
    end
  end
end
