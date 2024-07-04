module QuickScript
  concern :HelperMod do
    def tag(...)
      @tag ||= h.tag(...)
    end

    def h
      @h ||= ApplicationController.helpers
    end
  end
end
