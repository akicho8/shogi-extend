class VsClocksController < ApplicationController
  helper_method :vs_clock_options

  let :vs_clock_options do
    {
      post_path: url_for([controller_name.singularize, format: "json"]),
    }
  end

  def show
  end

  def create
  end
end
