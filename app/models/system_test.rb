module SystemTest
  extend self

  def active?
    return instance_variable_get("@active") if instance_variable_defined?("@active")
    @active ||= file.exist?
  end

  private

  def file
    @file ||= Rails.root.join("RSPEC_ACTIVE")
  end
end
