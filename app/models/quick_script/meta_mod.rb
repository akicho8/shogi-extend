module QuickScript
  concern :MetaMod do
    prepended do
      class_attribute :title, default: nil
      class_attribute :description, default: nil
      class_attribute :og_image_key, default: nil
    end

    def as_json(*)
      super.merge(meta: meta)
    end

    private

    def meta
      {
        :title        => title,
        :description  => description,
        :og_image_key => og_image_key,
      }
    end
  end
end
