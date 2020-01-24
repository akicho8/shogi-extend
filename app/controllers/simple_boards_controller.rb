class SimpleBoardsController < ApplicationController
  helper_method :simple_board_options

  let :simple_board_options do
    {
      post_path: url_for([controller_name.singularize, format: "json"]),
    }
  end

  def show
  end

  def create
  end
end
