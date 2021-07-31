class BoardGifGenerator < BoardImageGenerator
  class << self
    def file_format
      :gif
    end

    def cache_name
      "board_gif"
    end
  end
end
