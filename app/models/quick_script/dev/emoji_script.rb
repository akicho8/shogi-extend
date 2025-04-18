module QuickScript
  module Dev
    class EmojiScript < Base
      self.title = "絵文字"
      self.description = "絵文字のSVGを確認する"
      self.form_method = :get
      self.custom_style = ".QuickScriptView .big_emoji, .QuickScriptView .XemojiWrap { font-size: 128px; line-height: 1.0 }"

      def form_parts
        super + [
          {
            :label   => "絵文字",
            :key     => :emoji_text,
            :type    => :text,
            :dynamic_part => -> {
              {
                :default => current_emoji_text,
              }
            },
          },
          {
            :label   => "モード",
            :key     => :mode,
            :type    => :radio_button,
            :dynamic_part => -> {
              {
                :elems   => { "grapheme_cluster" => "結合", "single_code_point" => "分解", "info" => "詳細" },
                :default => current_mode,
              }
            },
          },
        ]
      end

      def call
        case current_mode
        when "grapheme_cluster"
          { _component: "XemojiWrap", _v_bind: { str: current_emoji_text } }
        when "single_code_point"
          values = current_emoji_text.chars.collect do |str|
            { _component: "XemojiWrap", _v_bind: { str: str } }
          end
          h_stack(values, :style => { "gap" => "0" })
        else
          rows = current_emoji_text.chars.collect do |str|
            {
              "font" => { _v_text: str, :class => "big_emoji" },
              "svg"  => { _component: "XemojiWrap", _v_bind: { str: str } },
              "code" => str.dump,
            }
          end
          simple_table(rows)
        end
      end

      def current_emoji_text
        # params[:emoji_text].presence || "🚴🏻‍♂️🏇🏿🍉🥕🍆🥦🥝🍩💀💩🧠🫀🔞🐶🐱🐹🐻🐼🐯🦁🐮🐷🐸🐵🦍🦧🐔🐦🐥🦊🐗🐴🦓🦌🦄🐬🦅🦆🦉🦩🦜🦔🐲🐞🐶🐱🐹🐻🐼️🐯🦁🐮🐷🐸🐵🦍🦧🐔🐧🐦🐤🐣🐥🐺🦊🦝🐗🐴🦓🦒🦌🦘🦥🦫🦄🐝🐛🦋🐌🪲🐞🐜🦗🪳🕷🦂🦟🪰🐢🐍🦎🐙🦑🦞🦀🐠🐟🐡🐬🦈🐳🐊🐆🐅🐄🦬🦣🦇🐓🦃🦅🦆🦢🦉🦩🦜🦤🦔🐲"
        params[:emoji_text].presence || "🚴🏻‍♂️🏇🏿🍉🧪⚗️🔬🧬"
      end

      def current_mode
        (params[:mode].presence || "grapheme_cluster").to_s
      end
    end
  end
end
