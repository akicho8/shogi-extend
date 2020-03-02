module Admin
  class ScriptsController < ::Admin::ApplicationController
    include ScriptsControllerMod

    def script_group
      BackendScript
    end
  end
end
