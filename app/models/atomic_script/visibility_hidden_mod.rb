module AtomicScript
  concern :VisibilityHiddenMod do
    included do
      # メニューには表示したくないとき true にする
      class_attribute :visibility_hidden_on_menu
      self.visibility_hidden_on_menu = false
    end

    class_methods do
      def menu_display?
        if Rails.env.production? || Rails.env.staging?
          if visibility_hidden_on_menu
            return false
          end
        end

        true
      end
    end
  end
end
