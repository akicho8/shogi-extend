class FallbackAvatarGenerator
  class << self
    def call(...)
      new(...).call
    end
  end

  attr_accessor :params

  def initialize(params = {})
    @params = {
      :count         => 8,
      :base_color    => "#00d1b2",
      :size          => 256,
      :output_dir    => Rails.root.join("app/assets/images/human"),
      :point_size    => 160,
      :label         => "?",
      :font          => "/Library/Fonts/Ricty-Bold.ttf",
      :file_format   => "%04d_fallback_avatar_icon.png",
      :execute       => false,
      :verbose       => Rails.env.local?,
    }.merge(params)
  end

  def call
    params[:count].times do |index|
      SingleGenerator.new(params.merge(index: index)).call
    end
  end

  class SingleGenerator
    attr_accessor :params

    def initialize(params)
      @params = params
    end

    def call
      if params[:verbose]
        puts command
      end
      if params[:execute]
        system(command, exception: true)
        puts file_path
      end
    end

    def command
      [
        "convert",
        "-fill '#{text_color.to_rgb.html}'",
        "-background '#{background_color.to_rgb.html}'",
        "-size #{size}x#{size}",
        "-gravity center",
        "-font #{font}",
        "-pointsize #{point_size}",
        "label:'#{label}'",
        file_path,
      ].join(" ")
    end

    def base_color
      Color::RGB.from_html(params[:base_color]).to_hsl
    end

    def background_color
      base_color.with(h: (1.0 / count) * index)
    end

    def text_color
      background_color.with(l: 0.97)
    end

    def count
      params[:count]
    end

    def index
      params[:index]
    end

    def size
      params[:size]
    end

    def font
      params[:font]
    end

    def point_size
      params[:point_size]
    end

    def label
      params[:label]
    end

    def output_dir
      Pathname(params[:output_dir]).expand_path
    end

    def file_path
      output_dir.join(params[:file_format] % index)
    end
  end
end
