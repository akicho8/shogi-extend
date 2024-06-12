# frozen-string-literal: true

module Swars
  module User::Stat
    module TagMethods
      ################################################################################ to_h だけに依存するメソッドたち

      def tags
        @tags ||= to_h.keys
      end

      def to_s
        @to_s ||= tags.join(",")
      end

      def exist?(tag)
        assert_tag(tag)
        to_h.has_key?(tag)
      end

      def include?(str)
        assert_string(str)
        to_s.include?(str)
      end

      def match?(value)
        to_s.match?(value)
      end
    end
  end
end
