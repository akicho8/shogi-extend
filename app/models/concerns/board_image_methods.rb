module BoardImageMethods
  extend ActiveSupport::Concern

  def to_browser_path(params = {})
    BoardImageGenerator.new(self, params).to_browser_path
  end

  def to_real_path(params = {})
    BoardImageGenerator.new(self, params).to_real_path
  end

  def to_gif_browser_path(params = {})
    BoardGifGenerator.new(self, params).to_browser_path
  end

  def to_gif_real_path(params = {})
    BoardGifGenerator.new(self, params).to_real_path
  end
end
