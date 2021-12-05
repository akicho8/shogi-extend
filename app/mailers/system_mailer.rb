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

  # rails r 'p SystemMailer.notify(subject: "(subject)", body: ENV.to_h.to_t, emoji: ":OK:").deliver_later'
  def notify(params = {})
    subject = []
    if v = params[:emoji]
      subject << EmojiInfo.lookup(v) || v
    end
    subject << app_name_prepend(params[:subject])
    subject = subject.join

    params = params.merge(subject: subject)
    params = params_normalize_if_fixed(params)
    mail(params)
  end
end
