module BoardImageMethods
  extend ActiveSupport::Concern

  def to_browser_path(params = {})
    BoardImageGenerator.new(self, params).to_browser_path
  end
end
