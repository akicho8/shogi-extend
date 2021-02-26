module Admin
  class ExampleScriptsController < ::Admin::ApplicationController
    include ScriptsControllerMethods

    def script_group
      AtomicScript::ExampleScript
    end
  end
end
