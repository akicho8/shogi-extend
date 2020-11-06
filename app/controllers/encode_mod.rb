module EncodeMod
  extend ActiveSupport::Concern

  def current_body_encode
    Encoding.find(params[:body_encode].presence || "UTF-8").to_s
  end

  private

  # (超重要) iOSの災いがこれですべて解決
  def current_type
    if current_body_encode == "Shift_JIS"
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

  def current_filename_encode
    Encoding.find(params[:filename_encode].presence || current_filename_encode_default).to_s
  end

  def current_filename_encode_default
    if filename_shift_jis?
      "Shift_JIS"
    else
      "UTF-8"
    end
  end

  # Windows では今は UTF-8 のファイル名で落とすことができるのでファイル名を変換する必要なし
  def filename_shift_jis?
    # request.user_agent.to_s.match?(/Windows/i) || boolean_for(params[:shift_jis]) || boolean_for(params[:Shift_JIS])
    boolean_for(params[:shift_jis]) || boolean_for(params[:Shift_JIS])
  end
end
