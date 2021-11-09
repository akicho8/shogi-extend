class SystemMailer < ApplicationMailer
  class << self
    # 例外をメール通知
    # development でも可
    #
    # rails r "p SystemMailer.notify_exception(Exception.new)"
    # rails r "p SystemMailer.notify_exception((1/0 rescue $!))"
    #
    def notify_exception(error, params = {})
      body = []
      if params.present?
        body << params.pretty_inspect
      end
      if error.backtrace
        body << error.backtrace.take(4).join("\n")
      end
      body = body.join("\n") + "\n"
      notify(subject: "#{error.message} (#{error.class.name})", body: body).deliver_later
    end
  end

  # rails r 'p SystemMailer.notify(subject: "(subject)", body: ENV.to_h.to_t).deliver_later'
  def notify(params = {})
    params = params.merge(subject: subject_decorate(params[:subject]))
    params = params_normalize(params)
    mail(params)
  end

  private

  # 表などが崩れないようにするための固定幅表示
  concerning :FixedFormatMethods do
    included do
      CSS_FONTS = %(Osaka-mono, "Osaka-等幅", "ＭＳ ゴシック", "Courier New", Consolas, monospace)
    end

    private

    def params_normalize(params)
      params = {
        fixed: false,
      }.merge(params)

      if true
        s = params[:body].presence || ""
        if s.respond_to?(:join)
          s = s.join
        end
        params[:body] = s
      end

      if params[:fixed]
        body = gmail_problem_workaround(params[:body])
        params.update(content_type: "text/html", body: pre_tag(body))
      end

      params
    end

    def pre_tag(text)
      %(<pre style='white-space: pre; font-family: #{CSS_FONTS}'>#{text}</pre>)
    end

    # GMailで改行が2重になる対策
    def gmail_problem_workaround(text)
      text.gsub("\n", "<br>")
    end
  end
end
