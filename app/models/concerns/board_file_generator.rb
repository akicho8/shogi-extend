class BoardFileGenerator
  class << self
    delegate :logger, to: "Rails"

    # base64で来ているデータを実際のファイルにしてパラメータを変更
    def params_rewrite!(params)
      logger.tagged(:params_rewrite!) do
        if params[:audio_theme_key] == "audio_theme_custom"
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

    # rails r 'BoardFileGenerator.old_media_file_clean'
    # rails r 'BoardFileGenerator.old_media_file_clean(keep: 0)'
    # rails r 'BoardFileGenerator.old_media_file_clean(keep: 3, execute: true)'
    # rails r 'BoardFileGenerator.old_media_file_clean(keep: 0, execute: true)'
    def old_media_file_clean(keep: 365, execute: false)
      logger.tagged(:old_media_file_clean) do
        files = tmp_media_file_dir.glob("*").sort
        files = files - files.last(keep)
        if files.present?
          all_files = files.flat_map { |e| e.glob("*") }
          SystemMailer.simple_track(subject: "古い曲ファイル削除", body: all_files.join("\n")).deliver_later
          FileUtils.rm_rf(files, noop: !execute, verbose: true)
        end
      end
    end

    def data_uri_to_tmpfile(e)
      bin = ApplicationRecord.data_uri_scheme_to_bin(e[:url])
      logger.info { "bin: #{bin.size} bytes" }
      logger.info { "attributes: #{e[:attributes].inspect}" }
      if false
        content_type = ApplicationRecord.data_uri_scheme_to_content_type(e[:url])
        extension = MiniMime.lookup_by_content_type(content_type).extension
        file_path = tmp_media_file_dir.join("#{SecureRandom.hex}.#{extension}")
      else
        basename = [SecureRandom.hex, e[:attributes][:name]].join("_")
        logger.info { "basename: #{basename}" }
        old_media_file_clean(keep: 3, execute: true) if false
        file_path = tmp_media_file_dir.join(Time.current.strftime("%Y%m%d"), basename)
      end
      logger.info { "file_path: #{file_path}" }
      logger.info { "pwd: #{Dir.pwd}" }
      file_path.dirname.mkpath
      file_path.binwrite(bin)
      logger.info { `ls -alh #{Shellwords.escape(file_path)}`.strip }
      file_path
    end

    def tmp_media_file_dir
      Rails.root.join("tmp/media_file")
    end
  end

  PAPPER = 2

  # FIXME: これらは params ではなく options にいれるべき？
  # params のうち、このクラスだけで扱うパラメータ
  PARAM_KEYS = [
    :recipe_key,
    :turn,
    # :video_fps,
    :basename_prefix,
  ]

  class << self
    def cache_root
      Rails.public_path.join("system", "x-files")
    end

    # cap production rails:runner CODE='BoardFileGenerator.cache_delete_all'
    def cache_delete_all
      FileUtils.rm_rf(cache_root)
    end

    def formatter_all_option_keys
      @formatter_all_option_keys ||= [
        Bioshogi::ImageRenderer,
        Bioshogi::Mp4Builder,
        Bioshogi::AnimationGifBuilder,
        Bioshogi::AnimationPngBuilder,
        Bioshogi::AnimationZipBuilder,
      ].flat_map { |e| e.default_params.keys }
    end
  end

  attr_accessor :record
  attr_accessor :params

  delegate :real_ext, to: :recipe_info

  delegate :logger, to: "Rails"

  def initialize(record, params = {}, options = {}, &block)
    @record = record

    if params.respond_to?(:to_unsafe_h)
      params = params.to_unsafe_h
    end

    @params = {
    }.merge(params.to_options)

    if false
      self.class.params_rewrite!(@params) # いらんか？
    end

    @options = {
      disk_cache_enable: Rails.env.production? || Rails.env.staging? || Rails.env.test? || Rails.env.development?,
      progress_callback: nil,
    }.merge(options)

    if block_given?
      yield self
    end
  end

  def to_browser_path
    generate_unless_exist
    browser_path
  end

  def to_real_path
    generate_unless_exist
    real_path
  end

  def cache_delete
    FileUtils.rm_f(real_path)
    FileUtils.rm_f("#{real_path}.rb")
  end

  def to_method_options
    @to_method_options ||= -> {
      opts = params.deep_symbolize_keys # dup を兼ねている
      opts = opts.slice(*self.class.formatter_all_option_keys) # unique_key の揺らぎ防止

      ImageSizeInfo.each do |e|
        if v = opts[e.key].presence || e.default
          opts[e.key] = v.to_i.clamp(-e.max, e.max)
        end
      end

      [
        { key: :one_frame_duration_sec, min: 1.fdiv(60), max: 5  }, # 0.0001 にされ  end_duration_sec = 7 なら70000個の画像を生成するはめになる
        { key: :end_duration_sec,       min: 0,          max: 30 },
      ].each do |e|
        if v = opts[e[:key]].presence
          opts[e[:key]] = v.clamp(e[:min], e[:max])
        end
      end

      opts = opts.merge(recipe_info.override_options)
    }.call
  end

  def turn
    @turn ||= record.adjust_turn(params[:turn])
  end

  def file_exist?
    real_path.exist?
  end

  # system/ だと /any/system になってしまうので / から始める
  def browser_path
    "/" + real_path.relative_path_from(Rails.public_path).to_s
  end

  def browser_url
    UrlProxy.wrap2(path: browser_path)
  end

  def generate_unless_exist
    if @options[:disk_cache_enable] && file_exist?
      return
    end

    force_generate
  end

  # ファイルの存在は問わない
  def real_path
    @real_path ||= self.class.cache_root.join(*dir_parts, disk_filename)
  end

  def recipe_key
    params[:recipe_key].presence || "is_recipe_png"
  end

  def recipe_info
    RecipeInfo.fetch(recipe_key)
  end

  # system 以下に格納するとき用のファイル名
  # 同じパラメータなら同じになるようにする
  # 2回同じパラメータで生成しようとしたときに、2回目に1回目のファイルを参照できるなくなるから日付を含めてはいけない
  def disk_filename
    # "#{basename_prefix}_#{basename_human_parts.join("_")}.#{real_ext}"
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
  #   # @ffprobe_direct ||= -> {
  #   if recipe_info.media_p
  #     if real_path.exist?
  #       JSON.parse(`ffprobe -v warning -print_format json -show_streams -hide_banner #{real_path}`)
  #     end
  #   end
  #   # }.call
  # end

  def file_size
    if real_path.exist?
      real_path.size
    end
  end

  private

  def unique_key
    @unique_key ||= Digest::MD5.hexdigest(unique_key_source_string)
  end

  # なるべく画像を共有したいのであってレコード毎にユニークにしたいわけじゃないので record.to_param を入れてはいけない
  def unique_key_source_string
    [
      PAPPER,
      recipe_info.key,
      record.sfen_hash,
      turn,
      to_method_options,
    ].join(":")
  end

  def to_blob
    parser = Bioshogi::Parser.parse(record.sfen_body, parser_options)
    parser.public_send(recipe_info.to_method, to_method_options.merge(progress_callback: @options[:progress_callback]))
  end

  def force_generate
    real_path.dirname.mkpath
    real_path.binwrite(to_blob)
    Pathname("#{real_path}.rb").write(to_method_options.pretty_inspect) # 同じディレクトリにどのようなオプションで生成したかを吐いておく
  end

  def dir_parts
    unique_key.match(/(.{2})(.{2})/).captures
  end

  # PNGを最速で生成するため戦術チェックなどスキップできるものはぜんぶスキップする
  def parser_options
    {
      # :skill_monitor_enable           => false,
      # :skill_monitor_technique_enable => false,
      :typical_error_case => :embed, # validate_enable しているのでこのオプションは使わない？
      :candidate_enable   => false,
      :validate_enable    => false,
      :mediator_class     => Bioshogi::MediatorFast,
      :turn_limit         => turn,
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

  def basename_prefix
    params[:basename_prefix].presence || unique_key.slice(0, 8)
  end
end
