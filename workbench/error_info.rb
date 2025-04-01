require "#{__dir__}/setup"

obj = ErrorInfo.new(((1 / 0) rescue $!), data: "(data)", backtrace_lines_max: 2)
tp obj.to_h
# >> |---------+-----------------------------------------------------------------------------------------------|
# >> |   emoji | :SOS:                                                                                         |
# >> | subject | ZeroDivisionError                                                                             |
# >> |    body | [MESSAGE]\ndivided by 0\n\n[BACKTRACE]\n-:3:in 'Integer#/'\n-:3:in '<main>'\n\n[DATA]\n(data) |
# >> |---------+-----------------------------------------------------------------------------------------------|
