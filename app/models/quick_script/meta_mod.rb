module QuickScript
  concern :MetaMod do
    prepended do
      class_attribute :og_image_key, default: nil
      class_attribute :og_card_size, default: nil
    end

    class_methods do
      def og_image_key_default
        @og_image_key_default ||= og_card_path.exist? ? name.underscore : :application # or :quick_script
      end

      def og_card_size_default
        @og_card_size_default ||= og_card_path.exist? ? :large : :small
      end

      def og_card_path
        Rails.root.join("nuxt_side/static/ogp/#{name.underscore}.png")
      end
    end

    def as_json(*)
      super.merge(meta: meta)
    end

    def meta_for_async_data
      meta
    end

    def meta
      super.merge({
          :og_image_key => og_image_key || self.class.og_image_key_default,
          :og_card_size => og_card_size || self.class.og_card_size_default,
        })
    end
  end
end
