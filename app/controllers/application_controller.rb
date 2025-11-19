class ApplicationController < ActionController::Base
  include CurrentUserMethods
  include AxiosMethods

  skip_forgery_protection :if => proc { request.format.json? || Rails.env.development? }

  before_action do
    # https://github.com/rails/rails/commit/0591de55af5cb1fa249237772309e94b07a640c2
    ActiveStorage::Current.url_options = { host: request.base_url }
  end

  before_action do
    request.env["exception_notifier.exception_data"] = {
      current_user_id: current_user&.id,
    }
  end

  # 強制的にBASIC認証を破棄する
  # http://localhost:3000/admin?invalidate_basic_auth=true
  def invalidate_basic_auth
    if params[:invalidate_basic_auth]
      if request.authorization.present?
        render html: %(BASIC認証を破棄しました。<br><a href="#{UrlProxy.full_url_for("/")}">TOP</a>).html_safe, status: :unauthorized
      end
    end
  end
  private :invalidate_basic_auth
  before_action :invalidate_basic_auth

  if Rails.env.development?
    before_action do
      logger.debug params.to_unsafe_h.to_t(truncate: 80)
    end
  end

  # http://localhost:3000/?test_request_info=1
  if Rails.env.local?
    before_action do
      if params[:test_request_info]
        AppLog.critical(((1 / 0) rescue $!), data: RequestInfo.new(self).to_s)
      end
    end
  end

  # http://localhost:3000/?force_error=1
  # https://www.shogi-extend.com/?force_error=1
  prepend_before_action do
    if params[:force_error]
      1 / 0
    end
  end

  before_action do
    if params[:__redirect_to]
      redirect_to params[:__redirect_to], params.permit![:__flash]
    end
  end

  def user_name_required
    if request.format.html?
      if current_user
        if current_user.auth_infos.exists?
          if current_user.name.blank?
            redirect_to [:edit, current_user], notice: "名前を入力しよう"
          end
        end
      end
    end
  end
  private :user_name_required
  before_action :user_name_required

  # for devise
  # ログインしたあとに移動するパス
  # https://noppleeeping.com/archives/2487
  def after_sign_in_path_for(resource_or_scope)
    return_to = session[:return_to] || :root
    session[:return_to] = nil

    # devise経由でログインしたときでも session と cookie に設定する
    # これを入れないと管理者でログインしたときに devise ではログインしているが
    # アプリではログインしたときは current_user が nil になってしまう
    current_user_set(resource_or_scope)

    return_to
  end

  def from_crawl_bot?
    # テスト中は常に PC 扱いする
    if RspecState.running?
      return false
    end

    if request.from_crawler?
      return true
    end

    # system test の場合は PC として扱いたいが production でもこれでクロールしてくるやつがいるためクローラー扱いとする
    # https://github.com/woothee/woothee/issues/75
    if v = request.user_agent
      if v.match?(/HeadlessChrome/i)
        return true
      end
    end

    false
  end

  concerning :ChoreMethods do
    included do
      add_flash_types *FlashInfo.all_keys
      helper_method :submitted?
    end

    def submitted?(name)
      params.key?(name)
    end

    private

    def boolean_for(v)
      v.to_s == "true" || v.to_s == "1"
    end

    def h
      @h ||= view_context
    end
    delegate :tag, :link_to, :icon_tag, :auto_link, to: :h
  end

  concerning :AdminUserMethods do
    included do
      helper_method :admin_user
    end

    private

    # スキップできるようにメソッド化
    def admin_login_required
      session.delete(:admin_user)
      authenticate_or_request_with_http_basic do |name, password|
        retval = name.present? && password == Rails.application.credentials[:basic_auth_password]
        if Rails.env.production? || Rails.env.test?
          Rails.cache.fetch(__method__, :expires_in => 30.minutes) do
            AppLog.important(subject: "管理画面ログイン", body: [retval, name, password].inspect)
            nil
          end
        end
        if retval
          session[:admin_user] ||= name.presence || "(admin_user)"
        end
        retval
      end
    end

    def admin_user
      session[:admin_user]
    end
  end

  concerning :RangeSupportMethods do
    # for Mobile Safari (iOS)
    # https://github.com/adamcooke/send_file_with_range
    #
    # ・Mobile Safari では send_file "file.mp4" で失敗する
    # ・Mobile Google Chrome では成功する
    # ・それならURLでmp4に直リンクでいいのでは？と思うかもしれない
    # ・しかし Mobile Safari では mp4 がダウンロードできない
    # ・これが致命的なので disposition: :attachment するために range 対応の send_file がいる
    # ・もう一つの利点としてはダウンロード時のファイル名を調整できること
    # ・Google Chrome で inline 表示するときこれにすると動かないので send_file を使う
    #
    def send_file_with_range(path, options = {})
      raise MissingFile, "Cannot read file #{path}" if !(File.file?(path) && File.readable?(path))

      if range_value = request.headers["range"]
        file_size = File.size(path)
        begin_point = 0
        end_point = file_size - 1
        status = :ok

        status = :partial_content
        # Google Chrome: "bytes=0-"
        # Mobile Safari: "bytes=0-1"
        if md = range_value.match(/bytes=(?<begin_point>\d+)-(?<end_point>\d+)?/)
          begin_point = md["begin_point"].to_i
          if md["end_point"]
            end_point = md["end_point"].to_i
          end
        end

        content_length = end_point - begin_point + 1
        response.header["Content-Range"] = "bytes #{begin_point}-#{end_point}/#{file_size}"
        response.header["Content-Length"] = content_length.to_s
        response.header["Accept-Ranges"] = "bytes"
        send_data IO.binread(path, content_length, begin_point), options.merge(status: status)
      else
        send_file path, options
      end
    end
  end
end
