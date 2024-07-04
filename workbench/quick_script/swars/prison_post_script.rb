require "./setup"
tp QuickScript::Swars::PrisonPostScript.new(_method: "post", swars_user_key: "foo").as_json # => {:body=>"testarossa00 はすでに収監観測済みです", :qs_page_key=>nil, :button_label=>"実行", :params_add_submit_key=>nil, :form_parts=>[{:label=>"将棋ウォーズID", :key=>:swars_user_key, :type=>:string, :default=>"foo"}], :__received_params__=>{:_method=>"post", :swars_user_key=>"foo"}, :form_method=>:post, :flash=>{}, :meta=>{:title=>"将棋ウォーズ囚人登録", :description=>"指定のウォーズIDが牢獄に入っていたら囚人とする", :og_image_key=>nil}, :redirect_to=>nil}
# >> |-----------------------+----------------------------------------------------------------------------------------------------------------------|
# >> |                  body | testarossa00 はすでに収監観測済みです                                                                                |
# >> |           qs_page_key |                                                                                                                      |
# >> |          button_label | 実行                                                                                                                 |
# >> | params_add_submit_key |                                                                                                                      |
# >> |            form_parts | [{:label=>"将棋ウォーズID", :key=>:swars_user_key, :type=>:string, :default=>"foo"}]                                 |
# >> |   __received_params__ | {:_method=>"post", :swars_user_key=>"foo"}                                                                           |
# >> |           form_method | post                                                                                                                 |
# >> |                 flash | {}                                                                                                                   |
# >> |                  meta | {:title=>"将棋ウォーズ囚人登録", :description=>"指定のウォーズIDが牢獄に入っていたら囚人とする", :og_image_key=>nil} |
# >> |           redirect_to |                                                                                                                      |
# >> |-----------------------+----------------------------------------------------------------------------------------------------------------------|
