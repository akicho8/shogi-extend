module QuickScriptNs
  class Base
    attr_reader :params

    def initialize(params = {})
      @params = params
    end

    def as_json(*)
      {
        :id                  => params[:id],
        :body                => call,
        :body_layout         => :auto,
        :get_button          => get_button,
        :meta                => meta,
        :form_parts          => form_parts,
        :__received_params__ => params,
      }
    end

    def call
    end

    private

    def form_parts
      []
    end

    def get_button
      false
    end

    def meta
      {
        :title        => "(title)",
        :description  => "(description)",
        :og_image_key => self.class.name.underscore,
      }
    end
  end
end
