class StopwatchesController < ApplicationController
  helper_method :stopwatch_options

  let :stopwatch_options do
    {
      post_path: url_for([controller_name.singularize, format: "json"]),
    }
  end

  def show
  end

  def create
    slack_message(key: "詰将棋RTA", body: "[#{params[:book_title]}][#{params[:mode]}] #{params[:summary].strip}")
  end
end
