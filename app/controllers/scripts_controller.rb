class ScriptsController < ApplicationController
  include ScriptsControllerMod

  def script_group
    FrontendScript
  end
end
