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
    [header, body].join("\n\n") + "\n"
  end

  private

  def header
    @params.collect { |key, value|
      if key.match?(/\A\W/)     # 日本語なら？
        "#{key}：#{value}"
      end
    }.compact.join("\n")
  end

  def body
    @params[:moves].collect { |e| e[:move] }.join(" ")
  end
end
