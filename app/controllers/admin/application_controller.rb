module Admin
  class ApplicationController < ::ApplicationController
    before_action :request_http_basic_authentication, :if => -> { params[:request_http_basic_authentication] }
    before_action :admin_login_required

    private

    # スキップできるようにメソッド化
    def admin_login_required
      authenticate_or_request_with_http_basic do |name, password|
        if name.present? && password == Rails.application.credentials[:admin_password]
          session[:admin_user] ||= name.presence || "(admin_user)"
          true
        else
          session.delete(:admin_user)
          false
        end
      end
    end

    helper_method :admin_user

    def admin_user
      session[:admin_user]
    end

    # include ControllerShared

    # 管理画面用ではないサーバーで管理画面にアクセスされたとき(ステージングのAPI側で/adminにアクセスしたときにエラーがでればOK)
    # if Rails.env.production? || Rails.env.staging?
    #   if AppInfo.api_server? && !AppInfo.dokku_server?
    #     before_action(prepend: true) do
    #       render :plain => "アクセスできません", :status => 404
    #     end
    #   end
    # end

    # helper LabelledFormHelper   # FIXME: 消す

    # # 揺らがないように常に nil で実行する
    # around_action {|_, block| Kamome.anchor(nil, &block) }
    #
    # before_action do
    #   if params[:reset_session]
    #     reset_session
    #   end
    # end
    #
    # before_action :staff_login_required
    #
    # before_action do |controller|
    #   controller.asset_host = nil
    # end
    #
    # before_action do |controller|
    #   controller.instance_eval do
    #     @module_name ||= "管理"
    #   end
    # end

    # include GeneralSupport
    # include StaffAuthorize

    private

    # def accessible_staff_only_if_login
    #   if admin_user
    #     unless admin_user.tag_list.include?("staff")
    #       deny_access
    #     end
    #   end
    # end

    # # 内部から発生したエラーのみ捕捉
    # if Rails.env.in?(["development", "test"])
    # else
    #   rescue_from ActionController::RoutingError, :with => :show_errors_and_rediret
    #   rescue_from ActiveRecord::RecordInvalid, :with => :show_errors_and_rediret
    #   rescue_from ActiveRecord::RecordNotFound, :with => :show_errors_and_rediret
    #
    #   def show_errors_and_rediret(exception)
    #     # render :text => exception.message
    #     # return
    #     message = exception.message
    #     case
    #     when request.xhr?
    #       render :ajax_error, {:locals => {:url => polymorphic_path(:admin), :message => message}}
    #     when request.format.html?
    #       redirect_to :admin, :alert => message
    #     else
    #       raise exception
    #     end
    #   end
    # end
  end
end
