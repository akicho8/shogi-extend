module Api
  class GeneralsController < ::Api::ApplicationController
    # curl http://localhost:3000/api/general/any_source_to?any_source=68S
    # curl http://localhost:3000/api/general/any_source_to -d "any_source=68S"
    # http://localhost:3000/api/general/any_source_to.txt?any_source=68S&to_format=kif
    # http://localhost:3000/api/general/any_source_to.txt?any_source=68S&to_format=ki2
    def any_source_to
      parser = KifuParser.new(params)
      respond_to do |format|
        format.json { render json: parser  }
        format.all  { render plain: parser }
      end
    end
  end
end
