class ApplicationController < ActionController::Base
  include CurrentUserMethods
  include AxiosMethods

  skip_forgery_protection :if => proc { request.format.json? || Rails.env.development? }

  before_action do
    ActiveStorage::Current.host = request.base_url
  end

  before_action do
    request.env["exception_notifier.exception_data"] = {
      current_user_id: current_user&.id,
    }
  end

  if Rails.env.development?
    before_action do
      logger.debug params.to_unsafe_h.to_t(truncate: 80)
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

  before_action :user_name_required

  def user_name_required
    if request.format.html?
      if current_user
        if current_user.auth_infos.exists?
          if current_user.name.blank?
            redirect_to [:edit, current_user], notice: "名前を入力してください"
          end
        end
      end
    end
  end

  # for devise
  # ログインしたあとに移動するパス
  # https://notsleeeping.com/archives/2487
  def after_sign_in_path_for(resource_or_scope)
    return_to = session[:return_to] || :root
    session[:return_to] = nil

    # devise経由でログインしたときでも session と cookie に設定する
    # これを入れないと管理者でログインしたときに devise ではログインしているが
    # アプリではログインしたときは current_user が nil になってしまう
    current_user_set(resource_or_scope)

    return_to
  end

  def from_googlebot?
    if v = request.user_agent
      v.match?(/Googlebot/i)
    end
  end

  concerning :ChoreMethods do
    included do
      add_flash_types *FlashInfo.all_keys
      helper_method :submitted?
      helper_method :slack_notify
    end

    def submitted?(name)
      params.key?(name)
    end

    def slack_notify(params = {})
      SlackAgent.notify(params)
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
        retv = name.present? && password == Rails.application.credentials[:admin_password]
        if Rails.env.production? || Rails.env.test?
          Rails.cache.fetch(__method__, :expires_in => 30.minutes) do
            slack_notify(subject: "管理画面ログイン", body: [retv, name, password].inspect)
            nil
          end
        end
        if retv
          session[:admin_user] ||= name.presence || "(admin_user)"
        end
        retv
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
      raise MissingFile, "Cannot read file #{path}" unless File.file?(path) && File.readable?(path)

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
