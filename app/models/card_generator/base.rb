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
        :base_color       => [0, 0.5, 0.5],   # ベース色
        :format           => "png",           # 出力する画像タイプ
        :debug            => false,

        # :variation        => 16,              # 色の数
        # :index            => nil,             # nil:ランダム 整数:hueをvariationで分割した位置
        :hue              => nil,             # nil:ランダム

        :font_file        => nil,             # フォント nil:自動 指定があるならそれ
        :font_luminance   => 0.98,            # フォントの輝度

        :stroke_darker    => 0.05,            # 縁取りの濃さ
        :stroke_width     => 3,               # 縁取りの太さ
        :stroke_antialias => true,            # 縁取りのアンチエイリアス (効いてない。常にtrue)
        :stroke_opacity   => 1.0,             # 縁取りの非透明度 (効いてない。常にtrue)
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
      file = "#{Dir.tmpdir}/#{Time.now.strftime('%Y%m%m%H%M%S')}_#{SecureRandom.hex}.png"
      canvas.write(file)
      system "open #{file}"
    end

    def canvas
      @canvas ||= -> {
        Magick::Image.new(*image_rect) do |e|
          e.background_color = background_color.html
        end
      }.call
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
      # base_s = "#00d1b2"
      # base_color = RGB::Color.from_rgb_hex(base_s)
      # count = 8
      # index = 0
      #
      # c = RGB::Color.from_fractions((1.0 / count) * index, base_color.s, base_color.l)
      # background = c.html               # => "#D10000", "#D19D00", "#69D100", "#00D134", "#00D1D1", "#0034D1", "#6800D1", "#D1009D"
      # fill = c.lighten_percent(97).html # => "#FFF6F6", "#FFFDF6", "#FAFFF6", "#F6FFF8", "#F6FFFF", "#F6F8FF", "#FAF6FF", "#FFF6FD"

      # font_color                  # => "#FFF6F6"
      # background_color            # => "#D10000"

      draw = Magick::Draw.new
      draw.gravity        = Magick::CenterGravity
      draw.font           = params[:font_file] || Bioshogi::ImageFormatter.default_params.fetch(:bold_font)
      draw.stroke_width   = params[:stroke_width]
      draw.stroke_opacity(params[:stroke_opacity])     # 効いてない (常に1.0)
      draw.stroke_antialias(params[:stroke_antialias]) # 効いてない (常にtrue)
      draw.stroke         = stroke_color.html
      draw.fill           = font_color.html
      draw.pointsize      = font_size
      draw.annotate(canvas, 0, 0, 0, 0, body)
    end

    def body
      @body ||= -> {
        if v = params[:body]
          v
        else
          "将棋問題集"
        end
      }.call
    end

    def font_size
      @font_size ||= -> {
        if v = params[:font_size]
          v
        else
          (params[:width] - 128) / (body.toeuc.bytesize / 2)
        end
      }.call
    end

    # def base_s
    #   params[:base_s]
    # end

    def variation
      params[:variation]
    end

    # def index
    #   @index ||= -> {
    #     if v = params[:index]
    #       v.modulo(variation)
    #     else
    #       rand(variation)
    #     end
    #   }.call
    # end

    def hue
      # base_color.h + (1.0 / variation) * index
      @hue ||= base_color.h + (params[:hue] || rand)
    end

    def base_color
      @base_color ||= Color::HSL.from_fraction(*params[:base_color])
    end

    def background_color
      # return Color::RGB.from_html("#FFFFFF").to_hsl
      @background_color ||= Color::HSL.from_fraction(hue, base_color.s, base_color.l)
    end

    def font_color
      @font_color ||= Color::HSL.from_fraction(hue, base_color.s, params[:font_luminance])
    end

    def stroke_color
      @stroke_color ||= Color::HSL.from_fraction(hue, base_color.s, base_color.l - params[:stroke_darker])
    end

    # # 格子色
    # def lattice_color
    #   params[:lattice_color] || params[:piece_color]
    # end
    #
    # def frame_color
    #   params[:frame_color] || params[:piece_color]
    # end

    # def frame_draw
    #   if frame_stroke_width
    #     draw_context do |c|
    #       c.stroke(frame_color)
    #       c.stroke_width(frame_stroke_width)
    #       c.stroke_linejoin("round") # 曲がり角を丸める 動いてない？
    #       c.fill = "transparent"
    #       c.rectangle(*px(V[0, 0]), *px(V[lattice.w, lattice.h])) # stroke_width に応じてずれる心配なし
    #     end
    #   end
    # end

    def draw_context
      c = Magick::Draw.new
      yield c
      c.draw(canvas)
    end

    # def px(v)
    #   top_left + v * cell_size
    # end

    # def line_draw(c, v1, v2)
    #   c.line(*px(v1), *px(v2))
    # end

    # def cell_draw(c, v)
    #   if v
    #     c.rectangle(*px(v), *px(v + V.one))
    #   end
    # end

    # def char_draw(pos:, text:, rotation:, color: params[:piece_color], bold: false, font_size: params[:font_size_hold])
    #   c = Magick::Draw.new
    #   c.rotation = rotation
    #   # c.font_weight = Magick::BoldWeight # 効かない
    #   c.pointsize = cell_size * font_size
    #   if bold
    #     c.font = params[:bold_font] || params[:normal_font]
    #   else
    #     c.font = params[:normal_font]
    #   end
    #   c.stroke = "transparent"
    #   # c.stroke_antialias(false) # 効かない？
    #   c.fill = color
    #   c.gravity = Magick::CenterGravity
    #   c.annotate(canvas, *cell_size_rect, *px(pos), text)
    # end

    def image_rect
      @image_rect ||= Rect[params[:width], params[:height]]
    end

    # def cell_size
    #   @cell_size ||= (vmin * params[:board_rate]) / lattice.h
    # end
    #
    # def vmin
    #   @vmin ||= image_rect.to_a.min
    # end
    #
    # def cell_size_rect
    #   @cell_size_rect ||= Rect[cell_size, cell_size]
    # end

    # def center
    #   @center ||= V[canvas.columns / 2, canvas.rows / 2]
    # end
    #
    # def top_left
    #   @top_left ||= center - lattice * cell_size / 2
    # end
    #
    # def v_bottom_right_outer
    #   @v_bottom_right_outer ||= V[lattice.w, lattice.h - 1]
    # end
    #
    # def v_top_left_outer
    #   @v_top_left_outer ||= V[-1, 0]
    # end
    #
    # def lattice_stroke_width
    #   params[:lattice_stroke_width]
    # end
    #
    # def frame_stroke_width
    #   params[:frame_stroke_width] || lattice_stroke_width
    # end

    class V < Vector
      def self.one
        self[1, 1]
      end

      def x
        self[0]
      end

      def y
        self[1]
      end
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
