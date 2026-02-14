require "matrix"
require "kconv"

module CardGenerator
  class Base
    cattr_accessor :default_params do
      {
        :body             => nil,             # 埋める文章
        :width            => 1200,            # 画像横幅
        :height           => 630,             # 画像縦幅
        :font_size        => nil,             # nil:自動的に決める 整数:それを使う
        :base_color       => [0.0, 0.5, 0.5], # ベース色
        :format           => "png",           # 出力する画像タイプ
        :debug            => false,

        :hue              => nil,             # nil:ランダム

        :font_file        => nil,             # フォント nil:自動 指定があるならそれ
        :font_luminance   => 0.98,            # フォントの輝度

        :stroke_darker    => 0.05,            # 縁取りの濃さ
        :stroke_width     => 3,               # 縁取りの太さ
        :stroke_antialias => true,            # 縁取りのアンチエイリアス (効いてない。常にtrue)
        :stroke_opacity   => 1.0,             # 縁取りの不透明度 (効いてない。常にtrue)

        :padding_lr       => 128 + 64 + 32,   # 左右のpadding
      }
    end

    class << self
      def render(*args)
        new(*args).tap(&:render)
      end

      def to_blob(*args)
        render(*args).to_blob
      end

      def display(*args)
        render(*args).display
      end
    end

    attr_accessor :params

    def initialize(params = {})
      require "rmagick"
      @params = default_params.merge(params)
      @rendered = false

      if params[:debug]
        tp info
      end
    end

    def render
      if @rendered
        return
      end
      main_render
      @rendered = true
    end

    def to_blob
      canvas.format = params[:format]
      canvas.to_blob
    end

    def display
      require "tmpdir"
      file = "#{Dir.tmpdir}/#{Time.now.strftime('%Y%m%d%H%M%S')}_#{SecureRandom.hex}.png"
      canvas.write(file)
      system "open #{file}"
    end

    def canvas
      @canvas ||= yield_self do
        Magick::Image.new(*image_rect) do |e|
          e.background_color = background_color.to_rgb.html
        end
      end
    end

    def info
      {
        :base_color       => base_color,
        :background_color => background_color,
        :stroke_color     => stroke_color,
        :font_color       => font_color,
      }
    end

    private

    def main_render
      draw = Magick::Draw.new
      draw.gravity        = Magick::CenterGravity
      draw.font           = (params[:font_file] || Bioshogi::ScreenImage::Renderer.default_params.fetch(:font_bold)).to_s
      draw.stroke_width   = params[:stroke_width]
      draw.stroke_opacity(params[:stroke_opacity])     # 効いてない (常に1.0)
      draw.stroke_antialias(params[:stroke_antialias]) # 効いてない (常にtrue)
      draw.stroke         = stroke_color.to_rgb.html
      draw.fill           = font_color.to_rgb.html
      draw.pointsize      = font_size
      draw.annotate(canvas, 0, 0, 0, 0, body)
    end

    def body
      @body ||= params[:body] || "(blank)"
    end

    def font_size
      @font_size ||= yield_self do
        if v = params[:font_size]
          v
        else
          (params[:width] - params[:padding_lr]) / body.toeuc.bytesize.fdiv(2).ceil
        end
      end
    end

    def hue
      @hue ||= base_color.h + (params[:hue] || rand)
    end

    def base_color
      @base_color ||= Color::HSL.new(*params[:base_color])
    end

    def background_color
      @background_color ||= Color::HSL.new(hue, base_color.s, base_color.l)
    end

    def font_color
      @font_color ||= Color::HSL.new(hue, base_color.s, params[:font_luminance])
    end

    def stroke_color
      @stroke_color ||= Color::HSL.new(hue, base_color.s, base_color.l - params[:stroke_darker])
    end

    def draw_context
      c = Magick::Draw.new
      yield c
      c.draw(canvas)
    end

    def image_rect
      @image_rect ||= Rect[params[:width], params[:height]]
    end

    class Rect < Vector
      def w
        self[0]
      end

      def h
        self[1]
      end
    end
  end
end
