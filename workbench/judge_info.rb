require "#{__dir__}/setup"
JudgeInfo[:Win]                 # => #<JudgeInfo:0x0000000126e9c4e8 @attributes={key: :win, name: "勝ち", short_name: "勝ち", ox_mark: "○", one_char: "勝", css_class: "has-text-weight-bold", flip_key: :lose, code: 0}>
JudgeInfo["Win"]                # => #<JudgeInfo:0x0000000126e9c4e8 @attributes={key: :win, name: "勝ち", short_name: "勝ち", ox_mark: "○", one_char: "勝", css_class: "has-text-weight-bold", flip_key: :lose, code: 0}>
JudgeInfo["WIN"]                # => #<JudgeInfo:0x0000000126e9c4e8 @attributes={key: :win, name: "勝ち", short_name: "勝ち", ox_mark: "○", one_char: "勝", css_class: "has-text-weight-bold", flip_key: :lose, code: 0}>
JudgeInfo.zero_default_hash.merge(a: 1) # => {win: 0, lose: 0, draw: 0, a: 1}
JudgeInfo[:win].flip.key        # => :lose
JudgeInfo["△"]                 # => #<JudgeInfo:0x0000000126e9c448 @attributes={key: :draw, name: "引き分け", short_name: "引分", ox_mark: "─", one_char: "△", css_class: "has-text-weight-normal", flip_key: nil, code: 2}>
