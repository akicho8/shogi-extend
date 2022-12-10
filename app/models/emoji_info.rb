# https://jp.piliapp.com/twitter-symbols/

class EmojiInfo
  include ApplicationMemoryRecord
  memory_record [
    { key: ":空白:",         raw: "▫", },
    { key: ":観戦チャット:", raw: "🙊", },
    { key: ":公開チャット:", raw: "😁", },
    { key: ":投了:",         raw: "😭", },
    { key: ":着手:",         raw: "🈯", },
    { key: ":指手不達:",     raw: "📴", },
    { key: ":動画:",         raw: "📽", },
    { key: ":問題:",         raw: "📄", },
    { key: ":問題集:",       raw: "📒", },
    { key: ":コメント:",     raw: "📝", },
    { key: ":棋譜ZIP:",      raw: "📗", },
    { key: ":SOS:",          raw: "🆘", },
    { key: ":目覚まし時計:", raw: "⏰", },
    { key: ":OK:",           raw: "🆗", },
    { key: ":CHECK:",        raw: "✅", },
    { key: ":X:",            raw: "❌", },
    { key: ":順番設定:",     raw: "🎎", },
    { key: ":対局時計:",     raw: "⏱", },
    { key: ":成功:",         raw: "🟢", },
    { key: ":失敗:",         raw: "🔴", },
    { key: ":得:",           raw: "🉐", },
    { key: ":プリンタ:",     raw: "🖨", },
    { key: ":外部アプリ:",   raw: "🅰", },
    { key: ":CHART:",        raw: "📊", },
    { key: ":NOT_FOUND:",    raw: "❓", },
    { key: ":LOG:",          raw: "🗒", },
    { key: ":棋譜:",         raw: "📝", },
    { key: ":勝ち:",         raw: "⭐", },
    { key: ":負け:",         raw: "🌧", },
    { key: ":救急:",         raw: "🚑", },
    { key: ":お題:",         raw: "📋", },
    { key: ":API:",          raw: "🅰", },
    { key: ":KENTO:",        raw: "🌝", },
  ]

  def to_s
    raw
  end
end
