module Api
  class QuickScriptsController < ::Api::ApplicationController
    # http://localhost:4000/script
    # http://localhost:3000/api/quick_scripts
    def index
      render json: QuickScriptNs::QuickScript.all_by(params.to_unsafe_h.symbolize_keys)
    end

    # http://localhost:4000/script/foo?bar=baz
    # http://localhost:3000/api/quick_scripts/foo?bar=baz
    def show
      render json: QuickScriptNs::QuickScript.fetch(params.to_unsafe_h.symbolize_keys)
    end
  end
end
