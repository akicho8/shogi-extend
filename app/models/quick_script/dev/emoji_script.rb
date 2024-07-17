module QuickScript
  module Dev
    class EmojiScript < Base
      self.title = "絵文字"
      self.description = "絵文字のSVGを確認する"
      self.form_method = :get

      def form_parts
        super + [
          {
            :label   => "絵文字",
            :key     => :emoji_text,
            :type    => :string,
            :default => emoji_text,
          },
        ]
      end

      def call
        rows = emoji_text.chars.collect do |char|
          {
            "ネイティブ"  => { _v_text: char, :style => emoji_style },
            "SVG"         => { _component: "XemojiWrap", _v_bind: { str: char }, :style => emoji_style },
            "dump"        => char.dump,
          }
        end
        simple_table(rows)
      end

      def emoji_style
        "font-size: 128px"
      end

      def emoji_text
        params[:emoji_text].presence || "🐶🐱🐹🐻🐼️🐯🦁🐮🐷🐸🐵🦍🦧🐔🐧🐦🐤🐣🐥🐺🦊🦝🐗🐴🦓🦒🦌🦘🦥🦫🦄🐝🐛🦋🐌🪲🐞🐜🦗🪳🕷🦂🦟🪰🐢🐍🦎🐙🦑🦞🦀🐠🐟🐡🐬🦈🐳🐊🐆🐅🐄🦬🦣🦇🐓🦃🦅🦆🦢🦉🦩🦜🦤🦔🐲"
      end
    end
  end
end
