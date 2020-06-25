class ScriptsController < ApplicationController
  include ScriptsControllerMod
  include EncodeMod

  def script_group
    FrontendScript
  end
end
