# Bmx.call { sleep(0.01) }.second  # => 0.012527999992016703
# Bmx.call { sleep(0.01) }         # => 0.012545 seconds

class Bmx
  class << self
    def call(...)
      new(...).tap(&:call)
    end
  end

  attr_reader :block
  attr_reader :second

  private_class_method :new

  def initialize(&block)
    @block = block
    @second = nil
  end

  def call
    @second = TimeTrial.second(&block)
  end

  def to_s
    ActiveSupport::Duration.build(second).inspect
  end

  def inspect
    to_s
  end
end
