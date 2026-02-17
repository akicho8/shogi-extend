require "./setup"
_ { QuickScript::Chore::NullScript.new.call } # => "8.33 ms"
s { QuickScript::Chore::NullScript.new.call } # => nil

QuickScript::Chore::NullScript.og_card_size # => nil
QuickScript::Chore::NullScript.new.meta     # => {:title=>"何もしない", :description=>"本当に何もしない", :og_image_key=>"quick_script/chore/null", :og_card_size=>:large, :primary_error_message=>nil}
QuickScript::Chore::NullScript.og_card_size_default # => :large
QuickScript::Chore::NullScript.og_card_path # => #<Pathname:/Users/ikeda/src/shogi/shogi-extend/nuxt_side/static/ogp/quick_script/chore/null_script.png>
# >> ["/Users/ikeda/src/shogi/shogi-extend/app/models/quick_script/chore/null_script.rb:8", :call]
# >> ["/Users/ikeda/src/shogi/shogi-extend/app/models/quick_script/chore/null_script.rb:8", :call]
