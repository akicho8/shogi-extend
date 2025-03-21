# frozen-string-literal: true

# moves = [{"m" => "7776FU", "t" => 383}, {"m" => "3334FU", "t" => 1492}]
# object = ShogiQuestToStandardCsa.new(moves: moves, user_names: ["a", "b"], created: Time.current)
# puts object.call
# # >> V2.2
# # >> N+a
# # >> N-b
# # >> $EVENT:将棋クエスト
# # >> $START_TIME:2025/03/19 20:22:35
# # >> +
# # >> +7776FU,T0
# # >> -3334FU,T0
# # >> %TORYO

class ShogiQuestToStandardCsa
  def initialize(params = {})
    @params = {
      :moves => [],
    }.merge(params)
  end

  def call
    to_csa
  end

  def to_csa
    @lines = []
    render_header
    render_body
    render_footer
    @lines.join("\n") + "\n"
  end

  private

  def render_header
    @lines << "V2.2"
    black, white = @params[:user_names]
    if v = black
      @lines << ["N+", v].join
    end
    if v = white
      @lines << ["N-", v].join
    end
    if v = event_title
      @lines << ["$EVENT", v] * ":"
    end
    if v = @params[:created]
      @lines << ["$START_TIME", v.to_fs(:csa_ymdhms)] * ":"
    end
    @lines << "+"
  end

  def render_body
    @params[:moves].each.with_index do |e, i|
      if e["m"]
        sign = i.even? ? :"+" : :"-"
        @lines << [sign, e["m"], ",", "T", 0].join
      end
    end
    @lines << "%TORYO"
  end

  def render_footer
  end

  def event_title
    "将棋クエスト"
  end
end
