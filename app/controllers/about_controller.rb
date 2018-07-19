class AboutController < ApplicationController
  def show
    # render html: Rails.root.join("config/#{params[:id]}.txt").read.gsub(/\R/, "<br/>").html_safe, layout: true
    # str = render_to_string(params[:id], layout: false)
    # str = str.gsub(/\R/, "<br/>").html_safe
    # render html: str
    render params[:id]
  end
end
