module Admin
  class ExampleScriptsController < ::Admin::ApplicationController
    include ScriptsControllerMod

    def script_group
      AtomicScript::ExampleScript
    end
  end
end
