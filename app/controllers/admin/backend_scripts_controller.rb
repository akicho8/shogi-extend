module Admin
  class BackendScriptsController < ::Admin::ApplicationController
    include ScriptsControllerMod

    def script_group
      BackendScript
    end
  end
end
