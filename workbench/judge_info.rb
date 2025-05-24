require "#{__dir__}/setup"
JudgeInfo[:Win]                 # => #<JudgeInfo:0x0000000124670f50 @attributes={key: :win, name: "勝ち", ox_mark: "○", one_char: "勝", css_class: "has-text-weight-bold", code: 0}>
JudgeInfo["Win"]                # => #<JudgeInfo:0x0000000124670f50 @attributes={key: :win, name: "勝ち", ox_mark: "○", one_char: "勝", css_class: "has-text-weight-bold", code: 0}>
JudgeInfo["WIN"]                # => #<JudgeInfo:0x0000000124670f50 @attributes={key: :win, name: "勝ち", ox_mark: "○", one_char: "勝", css_class: "has-text-weight-bold", code: 0}>
