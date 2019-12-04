class JosekisController < ApplicationController
  helper_method :joseki_options

  let :joseki_options do
    {
      post_path: url_for([controller_name.singularize, format: "json"]),
    }
  end

  def show
  end

  def create
    slack_message(key: "ストップウォッチ", body: "[#{params[:book_title]}][#{params[:mode]}] #{params[:summary].strip}")
  end
end
