class ScriptsController < ApplicationController
  include ScriptsControllerMethods
  include EncodeMethods

  def script_group
    FrontendScript
  end
end
