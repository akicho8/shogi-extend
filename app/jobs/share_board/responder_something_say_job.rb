module ShareBoard
  class ResponderSomethingSayJob < ApplicationJob
    queue_as :default

    def perform(params)
      ShareBoard::ChatAi::Responder::ResponderSomethingSay.new(params).call
    end
  end
end
