# talk, media_builder の共通処理

module SystemFileMethods
  extend ActiveSupport::Concern

  included do
    delegate :logger, to: "Rails"
  end

  class_methods do
    delegate :logger, to: "Rails"

    def output_subdir
      name.underscore
    end

    def output_root_dir
      Rails.public_path.join("system", output_subdir)
    end

    # cap production rails:runner CODE='MediaBuilder.cache_delete_all'
    def cache_delete_all
      FileUtils.rm_rf(output_root_dir)
    end

    # 実際の変換処理に渡すようなパラメータ
    def default_params
      {
      }
    end

    # SystemFileMethods 用のパラメータ
    def default_options
      {
        :disk_cache_enable => Rails.env.production? || Rails.env.staging? || Rails.env.test? || Rails.env.development?,
        :progress_callback => nil,
        :unique_key        => nil, # 明示的にキーを決める場合は指定。これがユニークだとキャッシュヒットしないため disk_cache_enable は false と似た状況になる
      }
    end
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
    if @options[:disk_cache_enable] && file_exist?
      return
    end

    force_build
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
end
