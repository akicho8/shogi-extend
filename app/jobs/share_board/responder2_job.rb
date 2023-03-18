module ShareBoard
  class Responder2Job < ApplicationJob
    queue_as :default

    def perform(params)
      ShareBoard::Responder2.new(params).call
    end
  end
end
