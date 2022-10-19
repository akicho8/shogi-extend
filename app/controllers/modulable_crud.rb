# This module is not a solid black boxed library.
# Basically all methods are designed to override.

module ModulableCrud
  concern :Base do
    included do
      if Rails.env.development?
        before_action do
          if !request.get?
            v = params.permit!.to_h
            begin
              Rails.cache.write(:before_post_params, v, expires_in: 1.minutes)
            rescue
            end
          end
        end
      end

      helper_method :ns_prefix
      helper_method :current_model
      helper_method :current_scope
      helper_method :current_single_key
      helper_method :current_param_key
      helper_method :respond_to_destroy?
      helper_method :respond_to_confirm?
      helper_method :current_record
    end

    # Examples
    #   :foo
    #   [:foo, :bar]
    #   self.class.parent_name.underscore
    #
    def ns_prefix
    end

    # override according to the situation
    def current_model
      @current_model ||= controller_path.classify.constantize
    end

    def current_scope
      @current_scope ||= current_model.all
    end

    def current_single_key
      @current_single_key ||= current_model.model_name.singular.to_sym
    end

    def current_param_key
      @current_param_key ||= current_model.model_name.param_key
    end

    def respond_to_destroy?
      respond_to?(:destroy)
    end

    def respond_to_confirm?
      self.class.ancestors.include?(ConfirmMethods)
    end

    # override according to the situation
    def current_record
      @current_record ||= yield_self do
        # current_scope.find_or_initialize_by(id: params[:id]) は危険
        if params[:id]
          current_scope.find(params[:id])
        else
          current_scope.new
        end
      end
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
  end

  concern :IndexMethods do
    included do
      helper_method :current_plural_key
      helper_method :current_records
      helper_method :js_current_records
    end

    def current_plural_key
      @current_plural_key ||= current_model.model_name.plural.to_sym
    end

    def current_records
      @current_records ||= current_scope.page(params[:page])
    end

    def js_current_records
      @js_current_records ||= current_records.collect { |e| js_record_for(e) }
    end

    def js_record_for(e)
      e.attributes
    end

    def index
      if request.xhr? && request.format.json?
        render json: js_current_records.to_json
        return
      end

      respond_to do |format|
        format.html
        format.json { render json: js_current_records }
      end
    end
  end

  concern :ShowMethods do
    included do
      helper_method :page_header_show_title
    end

    def page_header_show_title
      "詳細: ##{current_record.to_param}"
    end

    def show
    end
  end

  concern :NewEditSharedMethods do
    def create_or_update
      current_record.assign_attributes(current_record_params)
      save_and_redirect
    end

    def save_and_redirect
      current_record_session_clear
      if !current_record_save
        render :edit
        return
      end
      redirect_to_after_create_or_update
    end

    def current_record_session_clear
      session[current_single_key] = nil
    end

    # override according to the situation
    # [ns_prefix, current_plural_key]
    def redirect_to_where
      case
      when params[:_submit_and_redirect_to_show]
        [ns_prefix, current_record]
      when params[:_submit_and_redirect_to_edit]
        [:edit, ns_prefix, current_record]
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
        if !current_record_valid?
          render :edit
          return
        end
        # Make an attribute for when returning from the confirmation screen
        # When uploading a file etc, please leave that key in current_session_attributes
        session[current_single_key] = current_session_attributes
        render :confirm
      when _submit_from_confirm?
        # From the confirmation screen submit
        current_record.assign_attributes(session[current_single_key]) # Restoration
        save_and_redirect
      when _back_to_edit?
        # Return to edit from confirmation screen
        current_record.assign_attributes(session[current_single_key]) # Restoration
        render :edit
      else
        # Normal processing
        super
      end
    end

    # Data to restore when returning from the confirmation screen
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
      include NewEditSharedMethods
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
