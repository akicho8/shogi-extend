module QuickScript
  class QuickScriptError < StandardError; end
  class QuickScriptDoubleRedirect < QuickScriptError; end
  class QuickScriptDoubleCall < QuickScriptError; end
end
