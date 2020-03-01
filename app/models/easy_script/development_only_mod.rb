module EasyScript
  concern :DevelopmentOnlyMod do
    included do
      # メニューには表示したくないとき true にする
      class_attribute :development_only_show_on_menu
      self.development_only_show_on_menu = false
    end

    class_methods do
      def menu_display?
        if Rails.env.production? || Rails.env.staging?
          if development_only_show_on_menu
            return false
          end
        end

        true
      end
    end
  end
end
