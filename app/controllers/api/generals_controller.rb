module Api
  class GeneralsController < ::Api::ApplicationController
    # curl http://localhost:3000/api/general/any_source_to?any_source=68S
    # curl http://localhost:3000/api/general/any_source_to -d "any_source=68S"
    # http://localhost:3000/api/general/any_source_to.txt?any_source=68S&to_format=kif
    # http://localhost:3000/api/general/any_source_to.txt?any_source=68S&to_format=ki2
    def any_source_to
      # raise request.env.find_all {|k, v| k.to_s.match?(/\A(HTTP|REMOTE|SERVER)/) }.to_h.inspect
      # raise request.domain         #=> "localhost"
      info = {
        "request.headers['Referer']" => request.headers['Referer'],
        "request.headers['Origin']" => request.headers['Origin'],
        "request.headers['Host']" => request.headers['Host'],
        "request.referer"    => request.referer,
        "request.origin"     => request.origin,
        "request.from"       => request.from,
        "request.host"       => request.host,
        "request.user_agent" => request.user_agent,
        "env" => request.env.find_all {|k, v| k.to_s.match?(/\A(HTTP|REMOTE|SERVER)/) }.to_h,
      }
      # raise info.inspect
      SlackAgent.notify(subject: "any_source_to", body: info)
      parser = KifuParser.new(params)
      respond_to do |format|
        format.json { render json: parser  }
        format.all  { render plain: parser }
      end
    end
  end
end
