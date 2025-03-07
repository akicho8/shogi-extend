module QuickScript
  module Swars
    class BasicStatScript < Base
      self.title = "スプリントの先後勝率"
      self.description = "将棋ウォーズのスプリントの先後勝率を調べる"

      def call
        if Rails.env.local?
          cache_clear
        end
        values = []
        values << dottigatuyoi.to_component
        { _component: "QuickScriptViewValueAsV", _v_bind: { value: values, }, style: {"gap" => "1rem"} }
      end

      def dottigatuyoi
        @dottigatuyoi ||= Dottigatuyoi.new(self)
      end

      def cache_all
        delegate_objects.each(&:cache_write)
      end

      def cache_clear
        delegate_objects.each(&:cache_clear)
      end

      def delegate_objects
        [
          dottigatuyoi,
        ]
      end
    end
  end
end
