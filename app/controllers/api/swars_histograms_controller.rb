module Api
  # http://localhost:3000/api/swars_histogram.json
  class SwarsHistogramsController < ::Api::ApplicationController
    # http://localhost:3000/api/swars_histogram.json?key=grade
    # http://localhost:3000/api/swars_histogram.json?key=defense
    # http://localhost:3000/api/swars_histogram.json?key=attack
    # http://localhost:3000/api/swars_histogram.json?key=technique
    # http://localhost:3000/api/swars_histogram.json?key=note
    def show
      key = params[:key] || :attack
      render json: "swars/histogram/#{key}".classify.constantize.new(params)
    end
  end
end
