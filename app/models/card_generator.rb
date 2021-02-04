# -*- compile-command: "ruby card_generator.rb" -*-

if $0 == __FILE__
  require "bundler/inline"

  gemfile do
    gem "color"
    gem "rmagick"
    gem "bioshogi", github: "akicho8/bioshogi"
  end

  require "rmagick"
  require "rmagick/version"

  Magick::VERSION                 # => "4.1.2"
end

# require "rgb"
require "matrix"
require "kconv"

# Bioshogi::ImageFormatter.default_params[:normal_font] # => "/usr/local/var/rbenv/versions/2.7.0/lib/ruby/gems/2.7.0/bundler/gems/bioshogi-6faff3b4dfb8/lib/bioshogi/RictyDiminished-Regular.ttf"
# Bioshogi::ImageFormatter.default_params[:bold_font]   # => "/usr/local/var/rbenv/versions/2.7.0/lib/ruby/gems/2.7.0/bundler/gems/bioshogi-6faff3b4dfb8/lib/bioshogi/RictyDiminished-Bold.ttf"

class CardGenerator
  # cattr_accessor(:bold_font_file)    { Gem.find_files("bioshogi/RictyDiminished-Bold.ttf").first    }
  # cattr_accessor(:regular_font_file) { Gem.find_files("bioshogi/RictyDiminished-Regular.ttf").first }

  cattr_accessor :default_params do
    {
      :body            => nil,
      :width           => 1200, # 画像横幅
      :height          => 630,  # 画像縦幅
      :font_size       => nil,
      :index           => nil,
      :variation       => 16,
      :primary_color   => "#00d1b2", # hsl に分解して s, l だけ使う
      # :canvas_color    => "white",   # 下地の色(必須)
      # :piece_color     => "black",   # 駒の色(必須)
      :font_file     => Bioshogi::ImageFormatter.default_params[:bold_font],
      :format          => "png",   # 出力する画像タイプ
    }
  end

  class << self
    def render(*args)
      new(*args).tap(&:render)
    end
  end

  attr_accessor :params

  def initialize(params = {})
    require "rmagick"
    @params = default_params.merge(params)
    @rendered = false
  end

  def render
    if @rendered
      return
    end

    # primary_color = "#00d1b2"
    # base_color = RGB::Color.from_rgb_hex(primary_color)
    # count = 8
    # index = 0
    #
    # c = RGB::Color.from_fractions((1.0 / count) * index, base_color.s, base_color.l)
    # background = c.html               # => "#D10000", "#D19D00", "#69D100", "#00D134", "#00D1D1", "#0034D1", "#6800D1", "#D1009D"
    # fill = c.lighten_percent(97).html # => "#FFF6F6", "#FFFDF6", "#FAFFF6", "#F6FFF8", "#F6FFFF", "#F6F8FF", "#FAF6FF", "#FFF6FD"

    # font_color                  # => "#FFF6F6"
    # background_color            # => "#D10000"

    draw = Magick::Draw.new
    draw.font = params[:font_file]
    draw.gravity = Magick::CenterGravity
    draw.stroke_antialias(true) # 効いてない？
    draw.fill = font_color
    draw.pointsize = font_size
    draw.annotate(canvas, 0, 0, 0, 0, body)

    @rendered = true
  end

  def to_png
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
      # canvas = Magick::Image.new(*image_rect)
      # if params[:canvas_color]
      #   canvas.background_color = params[:canvas_color]
      # end
      # canvas.background_color = "blue"
      # canvas

      # PR したけど放置されている

      # list = Magick::ImageList.new
      # params = self.params
      # list.new_image(*image_rect) do |e|
      #   e.background_color = params[:canvas_color]
      # end

      # https://github.com/rmagick/rmagick/issues/699
      # https://github.com/rmagick/rmagick/pull/701
      params = self.params
      s = self
      image = Magick::Image.new(*image_rect) { |e|
        e.background_color = s.send(:background_color) # FIXME: PRしたけどまだgemに載ってない
      }

      # list = Magick::ImageList.new
      # list.new_image(*image_rect)
      # list.last.background_color = "red" # params[:canvas_color]
      # list
    }.call
  end

  private

  def body
    @body ||= -> {
      if v = params[:body]
        v
      else
        "０１２３４５６７８９０１２３４５"
        "アヒル戦法問題集"
      end
    }.call
  end

  def font_size
    if v = params[:font_size]
      v
    else
      (params[:width] - 128) / (body.toeuc.bytesize / 2)
    end
  end

  def primary_color
    params[:primary_color]
  end

  def base_color
    @base_color ||= Color::RGB.from_html(primary_color).to_hsl
  end

  def variation
    params[:variation]
  end

  def index
    if v = params[:index]
      v.modulo(variation)
    else
      rand(variation)
    end
  end

  def hue
    (1.0 / variation) * index
  end

  def background_color
    @background_color ||= Color::HSL.from_fraction(hue, base_color.s, base_color.l).html
  end

  def font_color
    @font_color ||= Color::HSL.from_fraction(hue, base_color.s, 90).html
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

  def center
    @center ||= V[canvas.columns / 2, canvas.rows / 2]
  end

  def top_left
    @top_left ||= center - lattice * cell_size / 2
  end

  def v_bottom_right_outer
    @v_bottom_right_outer ||= V[lattice.w, lattice.h - 1]
  end

  def v_top_left_outer
    @v_top_left_outer ||= V[-1, 0]
  end

  def lattice_stroke_width
    params[:lattice_stroke_width]
  end

  def frame_stroke_width
    params[:frame_stroke_width] || lattice_stroke_width
  end

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

if $0 == __FILE__
  # $LOAD_PATH << ".."
  # require "tree_support"
  obj = CardGenerator.new
  obj.render
  obj.display
end
