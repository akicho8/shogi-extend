module QuickScriptNs
  class RedirectScript < Base
    def call
      { redirect_to: "https://example.com/" }
    end

    private
  end
end
