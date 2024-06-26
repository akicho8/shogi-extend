module ShareBoard
  module ChatAi
    class Message
      attr_accessor :role
      attr_accessor :content

      def initialize(role, content)
        unless [:system, :user, :assistant].include?(role)
          raise TypeError, role.inspect
        end

        @role = role
        @content = content
      end

      def to_h
        {
          :role    => role.to_s,
          :content => content,
        }
      end

      def to_api
        to_h
      end

      def as_json(*)
        to_h
      end

      def inspect
        "<#{role}:#{content}>"
      end
    end
  end
end
