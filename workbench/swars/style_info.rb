require "./setup"
Swars::StyleInfo.fetch("王道")   # => #<Swars::StyleInfo:0x000000010addca60 @attributes={:key=>:王道, :code=>0}>
Swars::StyleInfo.fetch(:"王道")  # => #<Swars::StyleInfo:0x000000010addca60 @attributes={:key=>:王道, :code=>0}>
