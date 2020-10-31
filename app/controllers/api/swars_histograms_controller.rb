module Api
  # http://0.0.0.0:3000/api/swars_histogram.json
  class SwarsHistogramsController < ::Api::ApplicationController
    # http://0.0.0.0:3000/api/swars_histogram.json?key=grade
    # http://0.0.0.0:3000/api/swars_histogram.json?key=defense
    # http://0.0.0.0:3000/api/swars_histogram.json?key=attack
    # http://0.0.0.0:3000/api/swars_histogram.json?key=technique
    # http://0.0.0.0:3000/api/swars_histogram.json?key=note
    def show
      key = params[:key] || :attack
      render json: "swars/histogram/#{key}".classify.constantize.new(params)
    end
  end
end
