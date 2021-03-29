class SystemMailer < ApplicationMailer
  class << self
    # 例外をメール通知
    # development でも可
    #
    # rails r "p SystemMailer.notify_exception(Exception.new)"
    # rails r "p SystemMailer.notify_exception((1/0 rescue $!))"
    #
    def notify_exception(error)
      simple_track(subject: "#{error.message} (#{error.class.name})", body: [error.backtrace].compact.join("\n")).deliver_later
    end
  end

  # rails r 'p SystemMailer.fixed_track(subject: "(subject)", body: ENV.to_h.to_t).deliver_later'
  def fixed_track(params = {})
    mail(fixed_format(params.merge(subject: subject_decorate(params[:subject]))))
  end

  # rails r 'p SystemMailer.simple_track(subject: "(subject)", body: ENV.to_h.to_t).deliver_later'
  def simple_track(params = {})
    mail(params.merge(subject: subject_decorate(params[:subject])))
  end

  private

  # 表などが崩れないようにするための固定幅表示
  concerning :FixedFormatMethods do
    included do
      CSS_FONTS = %(Osaka-mono, "Osaka-等幅", "ＭＳ ゴシック", "Courier New", Consolas, monospace)
    end

    private

    def fixed_format(params)
      body = crln_to_br_for_gmail(params[:body].to_s)
      params.merge(content_type: "text/html", body: pre_tag(body))
    end

    def pre_tag(text)
      %(<pre style='white-space: pre; font-family: #{CSS_FONTS}'>#{text}</pre>)
    end

    # GMailで改行が2重になる対策
    def crln_to_br_for_gmail(text)
      text.gsub("\n", "<br>")
    end
  end
end
