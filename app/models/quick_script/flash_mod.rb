module QuickScript
  concern :FlashMod do
    def as_json(*)
      super.merge(flash: flash)
    end

    def flash
      @flash ||= {}
    end
  end
end
