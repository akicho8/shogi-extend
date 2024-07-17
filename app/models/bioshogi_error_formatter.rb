class BioshogiErrorFormatter
  def initialize(error)
    @error = error
  end

  def case_value_too_long
    av = []
    av << "棋譜データがでかすぎです。"
    av << "KIF形式であればSFEN形式に変換してみてください。"
    av << "かなり小さくなるのでエラーを回避できるでしょう。"
    av << "「動画作成」のところなら「トリム」で0から最終手までを選択すればただのSFEN変換になります。"
    av << @error.message
    { message: av.join }
  end

  def to_h
    {
      :message_prefix => message_prefix_build,
      :message        => @error.message.lines.first.strip,
      :board          => @error.message.lines.drop(1).join,
    }
  end

  def to_s
    [message_prefix_build, @error.message].compact.join(" ")
  end

  private

  def message_prefix_build
    av = []
    if @error.respond_to?(:container)
      av << "#{@error.container.turn_info.display_turn.next}手目"
      av << "#{@error.container.current_player.call_name}番"
    end
    if @error.respond_to?(:input)
      av << "#{@error.input.input.values.join}"
    end
    av.join(" ").squish.presence
  end
end
