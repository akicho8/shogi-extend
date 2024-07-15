require "./setup"
_ { QuickScript::Chore::NullScript.new.call } # => "3.65 ms"
s { QuickScript::Chore::NullScript.new.call } # => nil

QuickScript::Chore::NullScript.og_card_size # => nil
QuickScript::Chore::NullScript.new.meta     # => {:title=>"空", :description=>"何も実行しない", :og_image_key=>:quick_script, :og_card_size=>:large}
QuickScript::Chore::NullScript.og_card_size_default # => :large
QuickScript::Chore::NullScript.og_card_path # => #<Pathname:/Users/ikeda/src/shogi-extend/nuxt_side/static/ogp/quick_script/chore/null.png>
