class RelayBoardsController < ApplicationController
  helper_method :relay_board_options

  let :relay_board_options do
    {
      post_path: url_for([controller_name.singularize, format: "json"]),
    }
  end

  def show
  end

  def create
  end
end
