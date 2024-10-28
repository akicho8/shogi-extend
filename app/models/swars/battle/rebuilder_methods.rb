module Swars
  class Battle
    concern :RebuilderMethods do
      def rebuild(options = {})
        Rebuilder.new(self, options).call
      end
    end
  end
end
