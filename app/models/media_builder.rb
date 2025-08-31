class MediaBuilder
  include SystemFileMethods

  class << self
    # base64で来ているデータを実際のファイルにしてパラメータを変更
    def params_rewrite!(params)
      logger.tagged(:params_rewrite!) do
        if params[:audio_theme_key] == "is_audio_theme_custom"
          params[:audio_theme_key]     = nil
          params[:audio_part_a]        = nil
          params[:audio_part_a_volume] = 1.0
          params[:audio_part_b]        = nil
          params[:audio_part_b_volume] = 1.0

          if e = params.delete(:u_audio_file_a).presence
            params[:audio_part_a] = data_uri_to_tmpfile(e).to_s
          end
          if e = params.delete(:u_audio_file_b).presence
            params[:audio_part_b] = data_uri_to_tmpfile(e).to_s
          end
        end

        params[:renderer_override_params] ||= {}
        if e = params.delete(:u_bg_file).presence
          params[:renderer_override_params][:bg_file] = data_uri_to_tmpfile(e).to_s
        end
        if e = params.delete(:u_fg_file).presence
          params[:renderer_override_params][:fg_file] = data_uri_to_tmpfile(e).to_s
        end
        if e = params.delete(:u_pt_file).presence
          params[:renderer_override_params][:pt_file] = data_uri_to_tmpfile(e).to_s
        end
      end

      params
    end

    # rails r 'MediaBuilder.old_media_file_clean'
    # rails r 'MediaBuilder.old_media_file_clean(keep: 0)'
    # rails r 'MediaBuilder.old_media_file_clean(keep: 3, execute: true)'
    # rails r 'MediaBuilder.old_media_file_clean(keep: 0, execute: true)'
    def old_media_file_clean(keep: 365, execute: false)
      logger.tagged(:old_media_file_clean) do
        files = tmp_media_file_dir.glob("*").sort
        files = files - files.last(keep)
        if files.present?
          all_files = files.flat_map { |e| e.glob("*") }
          AppLog.important(subject: "古い曲ファイル削除", body: all_files.join("\n"))
          FileUtils.rm_rf(files, noop: !execute, verbose: true)
        end
      end
    end

    def data_uri_to_tmpfile(e)
      data_uri = DataUri.new(e[:url])
      logger.info { "bin: #{data_uri.to_blob.size} bytes" }
      logger.info { "attributes: #{e[:attributes].inspect}" }
      if false
        file_path = tmp_media_file_dir.join("#{SecureRandom.hex}.#{data_uri.extension}")
      else
        name = BasenameNormalizer.normalize(e[:attributes][:name])
        basename = [SecureRandom.hex, name].join("_")
        logger.info { "basename: #{basename}" }
        old_media_file_clean(keep: 3, execute: true) if false
        file_path = tmp_media_file_dir.join(Time.current.strftime("%Y%m%d"), basename)
      end
      logger.info { "file_path: #{file_path}" }
      logger.info { "pwd: #{Dir.pwd}" }
      file_path.dirname.mkpath
      file_path.binwrite(data_uri.read)
      logger.info { `ls -alh #{Shellwords.escape(file_path)}`.strip }
      file_path
    end

    def tmp_media_file_dir
      Rails.root.join("tmp/media_file") # config/deploy.rb と合わせる
    end
  end

  PAPPER = 4

  class << self
    def output_subdirs
      ["x-files", output_subdirs_env]
    end

    def formatter_all_option_keys
      @formatter_all_option_keys ||= [
        Bioshogi::ScreenImage::Renderer,
        Bioshogi::Formatter::Animation::AnimationMp4Builder,
        Bioshogi::Formatter::Animation::AnimationGifBuilder,
        Bioshogi::Formatter::Animation::AnimationApngBuilder,
        Bioshogi::Formatter::Animation::AnimationZipBuilder,
      ].flat_map { |e| e.default_params.keys }
    end

    # def default_options
    #   super.merge({
    #       cache_feature: Rails.env.production? || Rails.env.staging? || Rails.env.local?,
    #     })
    # end

    private

    def output_subdirs_env
      if Rails.env.local?
        Rails.env
      end
    end
  end

  attr_accessor :record

  delegate :real_ext, to: :recipe_info

  def initialize(record, params = {}, options = {}, &block)
    @record = record

    # NOTE: ここでキーを固定してはいけない。盤画像がキャッシュされなくなる。このクラスは動画専用ではない
    # options = options.merge(unique_key: record.key)

    super(params, options)

    if false
      self.class.params_rewrite!(@params) # いらんか？
    end

    if block_given?
      yield self
    end
  end

  def cache_delete
    super
    FileUtils.rm_f("#{real_path}.rb")
  end

  def build_options
    @build_options ||= yield_self do
      opts = params.deep_symbolize_keys # dup を兼ねている
      opts = opts.slice(*self.class.formatter_all_option_keys) # unique_key の揺らぎ防止

      ImageSizeInfo.each do |e|
        if v = opts[e.key].presence || e.default
          opts[e.key] = v.to_i.clamp(-e.max, e.max)
        end
      end

      [
        { key: :page_duration, min: 1.fdiv(60), max: 5  }, # 0.0001 にされ  end_duration = 7 なら70000個の画像を生成するはめになる
        { key: :end_duration,  min: 0,          max: 30 },
      ].each do |e|
        if v = opts[e[:key]].presence
          opts[e[:key]] = v.clamp(e[:min], e[:max])
        end
      end

      opts = opts.merge(recipe_info.override_options)
    end
  end

  def turn
    @turn ||= record.adjust_turn(params[:turn])
  end

  # system 以下に格納するとき用のファイル名
  # 同じパラメータなら同じになるようにする
  # 2回同じパラメータで生成しようとしたときに、2回目に1回目のファイルを参照できるなくなるから日付を含めてはいけない
  def disk_filename
    "#{unique_key}.#{real_ext}"
  end

  # Rails側からダウンロードするときのわかりやすい名前
  # def filename_human
  #   # "#{basename_prefix}_#{basename_human_parts.join("_")}.#{real_ext}"
  #   basename = basename_human_parts.join("_")
  #   "#{basename}.#{real_ext}"
  # end

  # def filename_human
  #   "#{basename_human}.#{real_ext}"
  # end

  def basename_human_parts(direct_format)
    raise ArgumentError if direct_format.blank?

    parts = []
    e = direct_format["streams"][0]

    if (w = e["width"]) && (h = e["height"])
      parts << "#{w}x#{h}"
    end

    if real_ext.in?(["mp4", "mov", "gif"])
      # if v = e["r_frame_rate"]
      #   parts << "#{v.to_i}fps" # おかしい？
      # end
      # if v = e["bit_rate"]
      #   parts << "br#{v.to_i / 1024}Kbit"
      # end
      if v = e["duration"]
        parts << "#{v.to_f.ceil}s"
      end
      # if v = e["pix_fmt"]
      #   parts << v
      # end
    else
      # ...
    end

    # end
    parts
  end

  def ffprobe_info
    if recipe_info.media_p
      if real_path.exist?
        Dir.chdir(real_path.dirname) do
          {
            :pretty_format => JSON.parse(`ffprobe -v warning -print_format json -show_streams -hide_banner -pretty #{real_path.basename}`),
            :direct_format => JSON.parse(`ffprobe -v warning -print_format json -show_streams -hide_banner         #{real_path.basename}`),
          }
        end
      end
    end
  end

  # def ffprobe_direct
  #   # @ffprobe_direct ||= yield_self do
  #   if recipe_info.media_p
  #     if real_path.exist?
  #       JSON.parse(`ffprobe -v warning -print_format json -show_streams -hide_banner #{real_path}`)
  #     end
  #   end
  #   # }.call
  # end

  def recipe_info
    RecipeInfo.fetch(recipe_key)
  end

  private

  # なるべく画像を共有したいのであってレコード毎にユニークにしたいわけじゃないので record.to_param を入れてはいけない
  def unique_key_source
    [
      PAPPER,
      recipe_info.key,
      record.sfen_hash,
      turn,
      build_options,
    ].join(":")
  end

  def to_blob
    info = Bioshogi::Parser.parse(record.sfen_body, parser_options)
    options = build_options.merge(progress_callback: @options[:progress_callback])
    info.public_send(recipe_info.to_method, options)
  end

  def force_build_core
    real_path.dirname.mkpath
    real_path.binwrite(to_blob)
    if Rails.env.local?
      Pathname("#{real_path}.rb").write(build_options.pretty_inspect) # 同じディレクトリにどのようなオプションで生成したかを吐いておく
    end
  end

  # PNGを最速で生成するため戦術チェックなどスキップできるものはぜんぶスキップする
  def parser_options
    {
      # :analysis_feature           => false,
      # :analysis_technique_feature => false,
      :typical_error_case => :embed, # validate_feature しているのでこのオプションは使わない？
      :ki2_function   => false,
      :validate_feature    => false,
      :analysis_feature    => false,
      :container_class     => Bioshogi::Container::Fast,
      :turn_max         => turn,
    }
  end

  # "-strict -2" はAACを使う場合に指定する
  # https://www.84kure.com/blog/2014/10/13/ffmpeg-%E3%82%88%E3%81%8F%E4%BD%BF%E3%81%86%E3%82%AA%E3%83%97%E3%82%B7%E3%83%A7%E3%83%B3%E8%A6%9A%E3%81%88%E6%9B%B8%E3%81%8D/
  # def yuv420_convert(bin)
  #   if recipe_info.force_convert_to_yuv420p
  #     i_path = real_path.dirname + "i_#{real_path.basename}"
  #     o_path = real_path.dirname + "o_#{real_path.basename}"
  #
  #     real_path.dirname.mkpath
  #     i_path.write(bin)
  #
  #     # command = "ffmpeg -y -i #{i_path} -vf 'scale=if(gte(iw\,ih)\,min(1280\,iw)\,-2):if(lt(iw\,ih)\,min(1280\,ih)\,-2)' -c:v libx264 -x264-params crf=16 -pix_fmt yuv420p -color_primaries bt709 -color_trc bt709 -colorspace bt709 -color_range tv -c:a copy #{o_path}"
  #     # command = "ffmpeg -y -i #{i_path} -vcodec libx264 -pix_fmt yuv420p -strict -2 -acodec aac -color_primaries bt709 -color_trc bt709 -colorspace bt709 -color_range tv -c:a copy #{o_path}"
  #
  #     # command = "ffmpeg -y -i #{i_path} -vcodec libx264 -pix_fmt yuv420p -strict -2 -acodec aac #{o_path}"
  #     # command = "ffmpeg -y -i #{i_path} -vcodec libx264 -pix_fmt yuv420p -crf 18 -preset medium -tune stillimage #{o_path}"
  #     audio_options = "-strict -2 -acodec aac"
  #     command = "ffmpeg #{ffmpeg_r_option} -v warning -hide_banner -y -i #{i_path} -vcodec libx264 -pix_fmt yuv420p #{o_path}"
  #
  #     # command = "ruby -e '1 / 0'"
  #     Pathname("#{real_path}.ffmpeg_command.txt").write(command.squish)
  #     # Dir.chdir(real_path.dirname) do
  #     case
  #     when false
  #       # ffmpeg が 1 で終了したことしかわからない
  #       system(command, exception: true)
  #     when true
  #       # ffmpeg が 1 で終了したときのエラー出力がわかる
  #       status, stdout, stderr = systemu(command)
  #       if !status.success?
  #         raise StandardError, stderr.strip
  #       end
  #     end
  #     # end
  #
  #     bin = o_path.read
  #
  #     if Rails.env.development?
  #     else
  #       FileUtils.rm_f(i_path)
  #       FileUtils.rm_f(o_path)
  #     end
  #   end
  #   bin
  # end

  # フレームレートを指定値に変換する。指定しない場合は入力ファイルの値を継承
  # http://mobilehackerz.jp/archive/wiki/index.php?%BA%C7%BF%B7ffmpeg%A4%CE%A5%AA%A5%D7%A5%B7%A5%E7%A5%F3%A4%DE%A4%C8%A4%E1
  # 小数で指定してはいけない
  # def ffmpeg_r_option
  #   if v = params[:video_fps].presence
  #     "-r #{v}"
  #   end
  # end

  def recipe_key
    params[:recipe_key].presence || "is_recipe_png"
  end
end
