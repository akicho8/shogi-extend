class FrontScriptsController < ApplicationController
  include ScriptsControllerMod

  def script_group
    FrontScript
  end
end
