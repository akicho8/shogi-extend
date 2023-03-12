module ShareBoard
  class Message
    # SEPARATOR = "/"

    attr_accessor :role
    attr_accessor :content

    # class << self
    #   def from_redis_value(redis_value)
    #     new(*redis_value.split(SEPARATOR, 2))
    #   end
    #   def from_json(value)
    #     value = JSON.parse(value, symbolize_names: true)
    #     new(*value.values_at(:role, :content))
    #   end
    # end

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

    # def to_redis_value
    #   [role, content] * SEPARATOR
    # end

    def as_json(*)
      to_h
    end

    def inspect
      "<#{role}:#{content}>"
    end
  end
end
