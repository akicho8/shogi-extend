module Swars
  module UserKeySuggestion
    extend self

    def message_for(str)
      Main.new(str).message
    end
  end
end
