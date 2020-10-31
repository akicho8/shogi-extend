module Swars
  module Histogram
    class Attack < Base
      def tactic_key
        self.class.name.demodulize.underscore.to_sym
      end
    end
  end
end
