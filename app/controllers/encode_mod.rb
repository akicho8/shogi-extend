module EncodeMod
  extend ActiveSupport::Concern

  def current_body_encode
    (params[:body_encode].presence || :utf8).to_sym
  end

  private

  def current_type
    if current_body_encode == :sjis
      "text/plain; charset=Shift_JIS"
    else
      "text/plain; charset=UTF-8"
    end
  end

  def current_disposition
    value = params[:disposition]

    unless value
      if key = [:inline, :attachment].find { |e| boolean_for(params[e]) }
        value ||= key
      end
    end

    (value || :inline).to_sym
  end

  def filename_encode
    (params[:filename_encode].presence || filename_encode_default).to_sym
  end

  def filename_encode_default
    if filename_sjis?
      :sjis
    else
      :utf8
    end
  end

  def filename_sjis?
    request.user_agent.to_s.match?(/Windows/i) || boolean_for(params[:shift_jis]) || boolean_for(params[:sjis])
  end

end
