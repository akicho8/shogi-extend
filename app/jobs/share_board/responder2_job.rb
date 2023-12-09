module ShareBoard
  class Responder2Job < ApplicationJob
    queue_as :default

    def perform(params)
      ShareBoard::ChatAi::Responder::Responder2.new(params).call
    end
  end
end
