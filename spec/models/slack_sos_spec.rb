require "rails_helper"

RSpec.describe SlackSos do
  it "works" do
    api_params = SlackSos.notify_exception((1/0 rescue $!), backtrace_lines_max: 0)
    assert { api_params[:text].include?("ZeroDivisionError") }
  end
end
