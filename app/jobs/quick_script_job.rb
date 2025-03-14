class QuickScriptJob < ApplicationJob
  queue_as :low

  def perform(params, options)
    QuickScript::Dispatcher.background_dispatch(params, options)
  end
end
