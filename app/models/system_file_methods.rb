# talk, media_builder の共通処理

module SystemFileMethods
  extend ActiveSupport::Concern

  class_methods do
    delegate :logger, to: "Rails"

    def output_subdirs
      name.underscore
    end

    def output_root_dir
      @output_root_dir ||= Rails.public_path.join("system", *Array(output_subdirs).compact)
    end

    # cap production rails:runner CODE='MediaBuilder.cache_delete_all'
    def cache_delete_all
      FileUtils.rm_rf(output_root_dir)
    end

    # 実際の変換処理に渡すようなパラメータ
    def default_params
      {}
    end

    # SystemFileMethods 用のパラメータ
    def default_options
      {
        :cache_feature     => Rails.env.production? || Rails.env.staging? || Rails.env.local?,
        :progress_callback => nil,
        :unique_key        => nil, # 明示的にキーを決める場合は指定。これがユニークだとキャッシュヒットしないため cache_feature は false と似た状況になる
      }
    end
  end

  included do
    delegate :logger, to: "self.class"
  end

  attr_accessor :params
  attr_accessor :options

  def initialize(params = {}, options = {})
    if params.respond_to?(:to_unsafe_h)
      params = params.to_unsafe_h
    end
    @params = self.class.default_params.merge(params.to_options)
    @options = self.class.default_options.merge(options.to_options)
  end

  def call
    as_json
  end

  def as_json(*)
    {
      browser_path: to_browser_path,
    }
  end

  def to_browser_path
    not_exist_then_build
    browser_path
  end

  def to_real_path
    not_exist_then_build
    real_path
  end

  # system/ だと /s/system になる
  def browser_path
    "/" + real_path.relative_path_from(Rails.public_path).to_s
  end

  # def browser_path_if_exist
  #   if e = real_path
  #     if e.exist?
  #       browser_path
  #     end
  #   end
  # end

  def browser_url
    UrlProxy.full_url_for(path: browser_path)
  end

  def not_exist_then_build
    if @options[:cache_feature] && file_exist?
      Rails.logger.debug { { "mtime更新前" => real_path.mtime.to_fs(:ymdhms) }.to_t }
      FileUtils.touch(real_path)
      Rails.logger.debug { { "mtime更新後" => real_path.mtime.to_fs(:ymdhms) }.to_t }
      log! "[already_existd]"
      return
    end
    force_build_wrap
  end

  def force_build_wrap
    ExclusiveAccess.new(unique_key).call do
      begin
        counter = Rails.cache.increment(unique_key)
        log! "[再入:#{counter}][begin]" # もし2になっていたらAPI実行中に同じAPIが再度呼ばれていて危険
        ms = "%.2f ms" % TimeTrial.ms { force_build_core }
        log! "[再入:#{counter}][end][#{ms}]"
      ensure
        Rails.cache.decrement(unique_key)
      end
    end
  end

  def force_build_core
    raise NotImplementedError, "#{__method__} is not implemented"
  end

  def real_path
    @real_path ||= self.class.output_root_dir.join(*dir_parts, disk_filename)
  end

  def cache_delete
    FileUtils.rm_f(real_path)
  end

  def file_size
    if file_exist?
      real_path.size
    end
  end

  def file_exist?
    real_path.exist?
  end

  def content_type
    if real_path
      if false
        # config/initializers/mime_types.rb が反映されていないため "xxx.apng" は nil.content_type になる
        MiniMime.lookup_by_filename(real_path).content_type
      else
        extname = real_path.extname[1..-1]           # => "apng"
        Mime::Type.lookup_by_extension(extname).to_s # => "image/apng"
      end
    end
  end

  def to_h
    {
      :cache_feature   => @options[:cache_feature],
      :unique_key      => unique_key,
      :to_browser_path => to_browser_path,
      :to_real_path    => to_real_path,
    }
  end

  private

  def disk_filename
    "#{unique_key}.bin"
  end

  def unique_key
    @unique_key ||= @options[:unique_key] || Digest::MD5.hexdigest(unique_key_source)
  end

  def unique_key_source
    raise NotImplementedError, "#{__method__} is not implemented"
  end

  def dir_parts
    unique_key.match(/(.{2})(.{2})/).captures
  end

  def log!(str)
    time = Time.now.strftime("%F %T %L")
    logger.info "[talk_mp3][#{time}][#{Process.pid}][#{unique_key}][#{params[:data]}]#{str}"
  end
end
