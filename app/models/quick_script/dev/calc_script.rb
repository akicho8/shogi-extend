module QuickScript
  module Dev
    class CalcScript < Base
      self.title = "計算機"
      self.description = "足し算を行う"
      self.form_method = :get

      # ~/src/shogi/shogi-extend/nuxt_side/components/QuickScript/QuickScriptView.vue
      def form_parts
        super + [
          {
            :label   => "左辺",
            :key     => :lhv,
            :type    => :numeric,
            :dynamic_part => -> {
              {
                :default => params[:lhv].presence.try { to_i } || 1,
              }
            },
          },
          {
            :label   => "演算子",
            :key     => :operator,
            :type    => :select,
            :dynamic_part => -> {
              {
                :elems   => ["+", "-"],
                :default => current_operator,
              }
            },
          },
          {
            :label   => "右辺",
            :key     => :rhv,
            :type    => :numeric,
            :dynamic_part => -> {
              {
                :default => params[:rhv].presence.try { to_i } || 2,
              }
            },
          },
        ]
      end

      def call
        current_lhv.public_send(current_operator, current_rhv)
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
