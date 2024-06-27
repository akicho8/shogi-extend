require "./setup"
Swars::StyleInfo.fetch("王道")   # => #<Swars::StyleInfo:0x000000012149d230 @attributes={:key=>:王道, :segment=>:majority, :code=>0}>
Swars::StyleInfo.fetch(:"王道")  # => #<Swars::StyleInfo:0x000000012149d230 @attributes={:key=>:王道, :segment=>:majority, :code=>0}>
