require "./setup"
MyController = Class.new(ActionController::Base)
MyController.class_eval do
  def foo
    render plain: "ok"
  end
end
my_controller = MyController.new
my_controller.request = ActionDispatch::Request.new({})
my_controller.response = ActionDispatch::Response.new
my_controller.foo
my_controller.response.body



