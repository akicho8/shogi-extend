module Admin
  class AdminScriptsController < ApplicationController
    before_action :load_object
    before_action :create_or_update, :only => [:create, :update]

    def show
      @admin_script.show_action
    end

    def create
    end

    def update
    end

    def create_or_update
      @admin_script.create_or_update_action
    end

    def load_object
      klass = "admin_script/#{params[:id]}".classify
      if real_klass = klass.safe_constantize
        @admin_script = real_klass.new(params.merge(:view_context => view_context, :controller => self))
      else
        redirect_to AdminScript::IndexScript.script_link_path, :notice => "#{klass} が見つかりません"
      end
    end
  end
end
