class Shogidb2Parser
  class << self
    def parse(*args)
      new(*args).parse
    end
  end

  def initialize(params, options = {})
    @params = params
    @options = {
      :trace => false,
    }.merge(options)

    if block_given?
      yield self
    end
  end

  def parse
    av = [*header]
    if v = body.presence
      av << v
    end
    if v = footer.presence
      av << v
    end
    av.join("\n") + "\n"
  end

  private

  def header
    av = []
    av << "V2.2"

    {
      "N+" => @params[:player1],
      "N-" => @params[:player2],
    }.each do |k, v|
      if v.present?
        av << "#{k}#{v}"
      end
    end

    {
      "$EVENT"      => @params[:tournament],
      "$SITE"       => @params[:place],
      "$START_TIME" => time_format(@params[:start_at]),
      "$END_TIME"   => time_format(@params[:end_at]),
    }.each do |k, v|
      if v.present?
        av << "#{k}:#{v}"
      end
    end

    if v = @params[:handicap]
      av << PresetInfo.fetch(v).to_board.to_csa.strip
    end

    if v = @params[:moves].first
      v = v[:csa]
      if v
        av << v[0]              # + or -
      end
    end

    av
  end

  def body
    @params[:moves].collect { |e|
      if v = e[:csa]
        if !v.start_with?("%")
          v
        end
      end
    }.compact.join(",")
  end

  def footer
    if v = @params[:moves].last
      if v = v[:csa]
        if v.start_with?("%")
          v
        end
      end
    end
  end

  def time_format(str)
    if str
      str.to_time.strftime("%Y/%m/%d %H:%M:%S")
    end
  end
end
