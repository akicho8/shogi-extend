module BatchTask
  class Base
    attr_accessor :params

    class << self
      def call(...)
        new(...).call
      end
    end

    def initialize(params = {})
      @params = {
        :execute => false,
        :verbose => false,
      }.merge(params)
    end

    def execute?
      params[:execute]
    end

    def verbose?
      params[:verbose]
    end

    def measure_block(&block)
      AppLog.important(subject: "#{subject}[開始]")
      bmx = Bmx.call(&block)
      AppLog.important(subject: "#{subject}[終了]", body: bmx.to_s)
    end

    def subject
      av = []
      av << "[#{self.class.name}]"
      if v = params[:name]
        av << "[#{v}]"
      end
      av.join
    end
  end
end
