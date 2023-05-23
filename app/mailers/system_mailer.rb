class SystemMailer < ApplicationMailer
  class << self
    # 例外をメール通知
    # development でも可
    #
    # rails r "p SystemMailer.notify_exception(Exception.new)"
    # rails r "p SystemMailer.notify_exception((1/0 rescue $!))"
    #
    def notify_exception(error, params = {})
      notify(ErrorInfo.new(error, params).to_h).deliver_later
    end
  end

  # rails r 'p SystemMailer.notify(subject: "(subject)", body: ENV.to_h.to_t, emoji: ":OK:").deliver_later'
  # rails r 'p SystemMailer.notify(subject: "(subject)", body: Time.current.to_s).deliver_now'
  def notify(params = {})
    subject = []
    if v = params[:emoji]
      subject << (EmojiInfo.lookup(v) || v)
    end
    subject << app_name_prepend(params[:subject])
    subject = subject.join

    params = params.merge(subject: subject)
    params = params_normalize_if_fixed(params)

    if hv = params[:attachments]
      hv.each do |k, v|
        attachments[k] = v
      end
    end

    mail(params)
  end
end
