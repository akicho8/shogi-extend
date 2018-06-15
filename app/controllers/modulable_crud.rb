# This module is not a solid black boxed library.
# Basically all methods are designed to override.

module ModulableCrud
  concern :Base do
    included do
      if Rails.env.development?
        before_action do
          unless request.get?
            v = params.permit!.to_h.except(:utf8)
            begin
              Rails.cache.write(:before_post_params, v, expires_in: 1.minutes)
            rescue
            end
          end
        end
      end

      before_action :record_load

      helper_method :ns_prefix
      helper_method :current_model
      helper_method :current_record
      helper_method :current_single_key
    end

    # override according to the situation
    #
    # Examples
    #   :foo
    #   [:foo, :bar]
    #   self.class.parent_name.underscore
    #
    def ns_prefix
    end

    # override according to the situation
    def current_model
      controller_path.classify.constantize
    end

    def current_scope
      current_model.all
    end

    def _goto_confirm?
      params[:_goto_confirm].present?
    end

    def _submit_from_confirm?
      params[:_submit_from_confirm].present?
    end

    def _back_to_edit?
      params[:_back_to_edit].present?
    end

    def current_single_key
      current_model.model_name.singular
    end

    def current_plural_key
      current_model.model_name.plural
    end

    def current_param_key
      current_model.model_name.param_key
    end

    def current_record
      instance_variable_get("@#{current_param_key}")
    end

    def current_record=(v)
      instance_variable_set("@#{current_param_key}", v)
    end

    def record_load
      self.current_record = raw_current_record
    end

    # override according to the situation
    def raw_current_record
      if v = params[:id].presence
        current_scope.find(v)
      else
        current_scope.new
      end
    end

    def respond_to_destroy?
      respond_to?(:destroy)
    end

    def respond_to_confirm?
      self.class.ancestors.include?(ConfirmMethods)
    end
  end

  concern :IndexMethods do
    included do
      helper_method :current_records
      helper_method :current_plural_key
    end

    def index
      self.current_records = current_scope.order(:id).reverse_order.page(params[:page])
    end

    def current_records
      instance_variable_get("@#{current_plural_key}")
    end

    def current_records=(v)
      instance_variable_set("@#{current_plural_key}", v)
    end
  end

  concern :ShowMethods do
    def show
    end

    def page_header_show_title
      "詳細: ##{current_record.to_param}"
    end
  end

  concern :NewEditShareMethods do
    def create_or_update
      current_record.assign_attributes(current_record_params)
      save_and_redirect
    end

    def save_and_redirect
      current_record_session_clear
      unless current_record_save
        render :edit
        return
      end
      redirect_to_after_create_or_update
    end

    def current_record_session_clear
      session[current_single_key] = nil
    end

    # override according to the situation
    def redirect_to_where
      if false
        [ns_prefix, current_record]
      else
        [ns_prefix, current_plural_key]
      end
    end

    def redirect_to_after_create_or_update
      redirect_to params[:redirect_to_where] || redirect_to_where, notice: notice_message
    end

    def notice_message
      if current_record.previous_changes[:id]
        label = "作成"
      else
        label = "更新"
      end
      "#{label}しました"
    end

    def current_record_valid?
      current_record.valid?
    end

    # override according to the situation
    def current_record_save
      current_record.save
    end

    # override according to the situation
    def current_record_params
      v = nil
      if params.has_key?(current_single_key)
        v = params.require(current_single_key)
        case
        when permit_all?
          v = v.permit!
        when current_permit_columns
          v = v.permit(current_permit_columns)
        else
          v = v.permit!
        end
      end
      v || {}
    end

    # override according to the situation
    def permit_all?
      true
    end

    # override according to the situation
    def current_permit_columns
      current_model.column_names.collect(&:to_sym) - [:id, :created_at, :updated_at]
    end
  end

  concern :ConfirmMethods do
    def create_or_update
      case
      when _goto_confirm?
        # 確認画面行き
        current_record.assign_attributes(current_record_params)
        unless current_record_valid?
          render :edit
          return
        end
        # 確認画面から戻ったとき用の属性を作っておく
        # ファイルアップロードしたときなどは current_session_attributes のなかで、そのキーを抜いておくこと
        session[current_single_key] = current_session_attributes
        render :confirm
      when _submit_from_confirm?
        # 確認画面からsubmit
        current_record.assign_attributes(session[current_single_key]) # 復元
        save_and_redirect
      when _back_to_edit?
        # 確認画面から編集に戻る
        current_record.assign_attributes(session[current_single_key]) # 復元
        render :edit
      else
        # 通常処理
        super
      end
    end

    # 確認画面から戻ったときに復元するデータ
    def current_session_attributes
      current_record_params
    end
  end

  concern :NewMethods do
    def new
      session[current_single_key] = nil
      current_record.assign_attributes(current_record_params)
      render :edit
    end

    def create
      create_or_update
    end
  end

  concern :EditMethods do
    def edit
      session[current_single_key] = nil
      current_record.assign_attributes(current_record_params)
      render :edit
    end

    def update
      create_or_update
    end
  end

  concern :DestroyMethods do
    def destroy
      current_record.destroy!
      redirect_to [ns_prefix, current_plural_key], notice: "削除しました"
    end
  end

  concern :ViewHelperMethods do
  end

  concern :All do
    included do
      include Base
      include IndexMethods
      include ShowMethods
      include NewEditShareMethods
      include NewMethods
      include EditMethods
      include DestroyMethods
      include ViewHelperMethods
    end
  end

  concern :AllWithConfirm do
    include All
    include ConfirmMethods
  end
end
