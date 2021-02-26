module Admin
  class ScriptsController < ::Admin::ApplicationController
    include ScriptsControllerMethods

    def script_group
      BackendScript
    end
  end
end
