module BoardImageMethods
  extend ActiveSupport::Concern

  def to_browser_path(params = {})
    MediaBuilder.new(self, params).to_browser_path
  end

  def to_real_path(params = {})
    MediaBuilder.new(self, params).to_real_path
  end
end
