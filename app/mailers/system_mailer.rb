class SystemMailer < ApplicationMailer
  # SystemMailer.fixed_track(subject: "(subject)", body: object.to_t).deliver_later
  def fixed_track(params = {})
    mail(fixed_format(params.merge(subject: subject_decorate(params[:subject]))))
  end

  # SystemMailer.simple_track(subject: "(subject)", body: "(body)").deliver_later
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
