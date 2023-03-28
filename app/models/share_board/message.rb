module ShareBoard
  class Message
    attr_accessor :role
    attr_accessor :content

    def initialize(role, content)
      @role = role
      @content = content
    end

    def to_h
      {
        :role    => role,
        :content => content,
      }
    end

    def to_gpt
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
