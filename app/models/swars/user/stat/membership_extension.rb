# frozen-string-literal: true

module Swars
  module User::Stat
    concern :MembershipExtension do
      def any_method1
        "OK"
      end
    end
  end
end
