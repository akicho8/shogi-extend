module ScriptsControllerMod
  extend ActiveSupport::Concern

  included do
    before_action :load_object
    before_action :create_or_update, :only => [:create, :update]
  end

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
    klass = script_group.find(params[:id])
    @script = klass.new(params.merge(:view_context => view_context, :controller => self))
  end

  def script_group
    raise NotImplementedError, "#{__method__} is not implemented"
  end
end
