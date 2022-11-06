module ForeignKey
  extend self

  def value
    ApplicationRecord.connection.select_value("SELECT @@FOREIGN_KEY_CHECKS") != 0
  end

  def value=(value)
    zero_or_one = value ? 1 : 0
    ApplicationRecord.connection.execute("SET FOREIGN_KEY_CHECKS = #{zero_or_one}")
  end

  def disabled?
    !value
  end

  def enabled?
    value
  end

  def enabled(&block)
    switch_context(true, &block)
  end

  def disabled(&block)
    switch_context(false, &block)
  end

  def new_context(&block)
    old_value = value
    begin
      yield
    ensure
      self.value = old_value
    end
  end

  private

  def switch_context(value, &block)
    if block_given?
      old_value = value
      self.value = value
      begin
        yield
      ensure
        self.value = old_value
      end
    else
      self.value = value
    end
  end
end
