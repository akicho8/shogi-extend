module Swars
  class Battle
    concern :RebuilderMethods do
      def rebuild
        Rebuilder.new(self).call
      end
    end
  end
end
