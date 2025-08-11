# frozen-string-literal: true

# 成功
#   rails r 'tp AdapterReceiver.call(input_text: "68銀")'
#   rails r 'tp AdapterReceiver.call(input_text: "")'
# 失敗
#   rails r 'AdapterReceiver.call(input_text: "58金") rescue (p $!.message)'
#
class AdapterReceiver
  class << self
    def call(...)
      new(...).call
    end
  end

  attr_reader :params

  def initialize(params)
    @params = params
  end

  def call
    @record = FreeBattle.create!(kifu_body: params[:input_text], use_key: "adapter")
    AppLog.info(**logger_params)
    @record.as_json(root: :record, methods: [:all_kifs, :display_turn, :piyo_shogi_base_params])
  rescue Bioshogi::BioshogiError => @error
    AppLog.error(**logger_params)
    raise @error
  end

  private

  def logger_params
    { emoji: emoji, subject: subject, body: body }
  end

  def turn_max
    if @record
      @record.turn_max
    end
  end

  def emoji
    if @error
      ":失敗:"
    else
      ":成功:"
    end
  end

  def subject
    av = []
    av << "なんでも棋譜変換"
    if params[:current_user]
      av << params[:current_user].name
    end
    if turn_max
      av << "[手数:#{turn_max}]"
    end
    if @error
      av << @error.class.name
    end
    av.join(" ")
  end

  def body
    av = []

    if params[:current_user]
      av << params[:current_user].info.to_t.strip
      av << ""
    end

    av += request_part

    if @error
      av << "▼エラー"
      av << @error.message.strip
      av << ""
    end

    av << "▼棋譜(入力)"
    av << params[:input_text]&.strip
    av << ""

    if @record
      av << "▼棋譜(変換後)"
      av << @record.to_xxx(:kif)
      av << ""
    end

    av.join("\n")
  end

  def request_part
    av = []
    if request = params[:request]
      av << "▼リクエスト"
      av << {
        :referer      => request.referer,      #=> "http://www.google.com/search?q=glu.ttono.us"
        :user_agent   => request.user_agent,   #=> "Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en)"
        :remote_addr  => request.remote_addr,  #=> "207.7.108.53"
        :remote_host  => request.remote_host,  #=> "google.com"
        :remote_ident => request.remote_ident, #=> "kevin"
        :remote_user  => request.remote_user,  #=> "kevin"
      }.to_t
    end
    av
  end
end
