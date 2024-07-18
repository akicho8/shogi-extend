module QuickScript
  concern :CustomStyleMod do
    prepended do
      class_attribute :custom_style, default: nil
    end

    def as_json(*)
      super.merge(custom_style: custom_style.to_s.squish.presence)
    end
  end
end
