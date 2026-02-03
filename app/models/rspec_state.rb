module RspecState
  extend self

  def running?
    Rails.env.local? && file_path.exist?
  end

  private

  def file_path
    @file_path ||= Rails.root.join("__RSPEC_RUNNING__")
  end
end
