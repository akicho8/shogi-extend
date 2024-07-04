module QuickScript
  concern :RedirectMod do
    def as_json(*)
      super.merge(redirect_to: @redirect_to_options)
    end

    def redirect_to(path, options = {})
      if @redirect_to_options
        raise AbstractController::DoubleRenderError
      end
      @redirect_to_options = { to: path, **options }
      nil
    end
  end
end
