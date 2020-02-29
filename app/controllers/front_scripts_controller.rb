class FrontScriptsController < ApplicationController
  before_action :load_object
  before_action :create_or_update, :only => [:create, :update]

  def show
    @script.show_action
    if performed?
      return
    end

    render :html => @script.render_in_view, layout: true
  end

  def create
  end

  def update
  end

  def create_or_update
    @script.create_or_update_action
  end

  def load_object
    klass = FrontScript.find(params[:id])
    @script = klass.new(params.merge(:view_context => view_context, :controller => self))
  end
end
