require "pathname"
require "active_support/all"

dir = Pathname("~/src/shogi-extend/app/models/quick_script").expand_path
dir.glob("**/*.rb") do |src|
  klass_name = src.to_s.remove(".rb", /.*quick_script\//).classify
  dst = src.to_s.sub(/.*\/app\//, "/Users/ikeda/src/shogi-extend/spec/")
  dst = dst.sub(".rb", "_spec.rb")
  dst = Pathname(dst)

  puts src
  puts dst

  content = <<~EOT
require "rails_helper"

module QuickScript
  RSpec.describe #{klass_name}, type: :model do
    it "works" do
      assert { #{klass_name}.new.call }
    end
  end
end
EOT
  unless dst.exist?
    FileUtils.makedirs(dst.dirname)
    dst.write(content)
  end

  klass_name = src.to_s.remove(".rb", /.*quick_script\//).classify
  dst = src.to_s.sub(/.*\/app\/models\//, "/Users/ikeda/src/shogi-extend/workbench/")
  # dst = dst.sub(".rb", "_spec.rb")
  dst = Pathname(dst)

  puts src
  puts dst

  unless dst.exist?
    content = <<~EOT
require "./setup"
_ { QuickScript::#{klass_name}.new.call } # =>
s { QuickScript::#{klass_name}.new.call } # =>
EOT
    FileUtils.makedirs(dst.dirname)
    dst.write(content)
  end
end

# >> /Users/ikeda/src/shogi-extend/app/models/quick_script/admin/login_script.rb
# >> /Users/ikeda/src/shogi-extend/spec/models/quick_script/admin/login_script.rb
# >> /Users/ikeda/src/shogi-extend/app/models/quick_script/admin/swars_agent_script.rb
# >> /Users/ikeda/src/shogi-extend/spec/models/quick_script/admin/swars_agent_script.rb
# >> /Users/ikeda/src/shogi-extend/app/models/quick_script/autoexec_mod.rb
# >> /Users/ikeda/src/shogi-extend/spec/models/quick_script/autoexec_mod.rb
# >> /Users/ikeda/src/shogi-extend/app/models/quick_script/base.rb
# >> /Users/ikeda/src/shogi-extend/spec/models/quick_script/base.rb
# >> /Users/ikeda/src/shogi-extend/app/models/quick_script/chore/group_script.rb
# >> /Users/ikeda/src/shogi-extend/spec/models/quick_script/chore/group_script.rb
# >> /Users/ikeda/src/shogi-extend/app/models/quick_script/chore/index_script.rb
# >> /Users/ikeda/src/shogi-extend/spec/models/quick_script/chore/index_script.rb
# >> /Users/ikeda/src/shogi-extend/app/models/quick_script/chore/invisible_script.rb
# >> /Users/ikeda/src/shogi-extend/spec/models/quick_script/chore/invisible_script.rb
# >> /Users/ikeda/src/shogi-extend/app/models/quick_script/chore/message_script.rb
# >> /Users/ikeda/src/shogi-extend/spec/models/quick_script/chore/message_script.rb
# >> /Users/ikeda/src/shogi-extend/app/models/quick_script/chore/status_code_script.rb
# >> /Users/ikeda/src/shogi-extend/spec/models/quick_script/chore/status_code_script.rb
# >> /Users/ikeda/src/shogi-extend/app/models/quick_script/chore/null_script.rb
# >> /Users/ikeda/src/shogi-extend/spec/models/quick_script/chore/null_script.rb
# >> /Users/ikeda/src/shogi-extend/app/models/quick_script/controller_mod.rb
# >> /Users/ikeda/src/shogi-extend/spec/models/quick_script/controller_mod.rb
# >> /Users/ikeda/src/shogi-extend/app/models/quick_script/dev/calc_script.rb
# >> /Users/ikeda/src/shogi-extend/spec/models/quick_script/dev/calc_script.rb
# >> /Users/ikeda/src/shogi-extend/app/models/quick_script/dev/download_get_script.rb
# >> /Users/ikeda/src/shogi-extend/spec/models/quick_script/dev/download_get_script.rb
# >> /Users/ikeda/src/shogi-extend/app/models/quick_script/dev/download_post_script.rb
# >> /Users/ikeda/src/shogi-extend/spec/models/quick_script/dev/download_post_script.rb
# >> /Users/ikeda/src/shogi-extend/app/models/quick_script/dev/error_script.rb
# >> /Users/ikeda/src/shogi-extend/spec/models/quick_script/dev/error_script.rb
# >> /Users/ikeda/src/shogi-extend/app/models/quick_script/dev/fetch_index_script.rb
# >> /Users/ikeda/src/shogi-extend/spec/models/quick_script/dev/fetch_index_script.rb
# >> /Users/ikeda/src/shogi-extend/app/models/quick_script/dev/flash_script.rb
# >> /Users/ikeda/src/shogi-extend/spec/models/quick_script/dev/flash_script.rb
# >> /Users/ikeda/src/shogi-extend/app/models/quick_script/dev/form_script.rb
# >> /Users/ikeda/src/shogi-extend/spec/models/quick_script/dev/form_script.rb
# >> /Users/ikeda/src/shogi-extend/app/models/quick_script/dev/hello_script.rb
# >> /Users/ikeda/src/shogi-extend/spec/models/quick_script/dev/hello_script.rb
# >> /Users/ikeda/src/shogi-extend/app/models/quick_script/dev/html_script.rb
# >> /Users/ikeda/src/shogi-extend/spec/models/quick_script/dev/html_script.rb
# >> /Users/ikeda/src/shogi-extend/app/models/quick_script/dev/invisible_script.rb
# >> /Users/ikeda/src/shogi-extend/spec/models/quick_script/dev/invisible_script.rb
# >> /Users/ikeda/src/shogi-extend/app/models/quick_script/dev/login_required1_script.rb
# >> /Users/ikeda/src/shogi-extend/spec/models/quick_script/dev/login_required1_script.rb
# >> /Users/ikeda/src/shogi-extend/app/models/quick_script/dev/login_required2_script.rb
# >> /Users/ikeda/src/shogi-extend/spec/models/quick_script/dev/login_required2_script.rb
# >> /Users/ikeda/src/shogi-extend/app/models/quick_script/dev/navibar_false_script.rb
# >> /Users/ikeda/src/shogi-extend/spec/models/quick_script/dev/navibar_false_script.rb
# >> /Users/ikeda/src/shogi-extend/app/models/quick_script/dev/null_script.rb
# >> /Users/ikeda/src/shogi-extend/spec/models/quick_script/dev/null_script.rb
# >> /Users/ikeda/src/shogi-extend/app/models/quick_script/dev/post1_script.rb
# >> /Users/ikeda/src/shogi-extend/spec/models/quick_script/dev/post1_script.rb
# >> /Users/ikeda/src/shogi-extend/app/models/quick_script/dev/post2_form_counter_script.rb
# >> /Users/ikeda/src/shogi-extend/spec/models/quick_script/dev/post2_form_counter_script.rb
# >> /Users/ikeda/src/shogi-extend/app/models/quick_script/dev/post3_session_counter_script.rb
# >> /Users/ikeda/src/shogi-extend/spec/models/quick_script/dev/post3_session_counter_script.rb
# >> /Users/ikeda/src/shogi-extend/app/models/quick_script/dev/post_and_redirect_script.rb
# >> /Users/ikeda/src/shogi-extend/spec/models/quick_script/dev/post_and_redirect_script.rb
# >> /Users/ikeda/src/shogi-extend/app/models/quick_script/dev/redirect1_script.rb
# >> /Users/ikeda/src/shogi-extend/spec/models/quick_script/dev/redirect1_script.rb
# >> /Users/ikeda/src/shogi-extend/app/models/quick_script/dev/redirect2_script.rb
# >> /Users/ikeda/src/shogi-extend/spec/models/quick_script/dev/redirect2_script.rb
# >> /Users/ikeda/src/shogi-extend/app/models/quick_script/dev/session_counter_script.rb
# >> /Users/ikeda/src/shogi-extend/spec/models/quick_script/dev/session_counter_script.rb
# >> /Users/ikeda/src/shogi-extend/app/models/quick_script/dev/session_script.rb
# >> /Users/ikeda/src/shogi-extend/spec/models/quick_script/dev/session_script.rb
# >> /Users/ikeda/src/shogi-extend/app/models/quick_script/dev/sheet_script.rb
# >> /Users/ikeda/src/shogi-extend/spec/models/quick_script/dev/sheet_script.rb
# >> /Users/ikeda/src/shogi-extend/app/models/quick_script/dev/sleep_script.rb
# >> /Users/ikeda/src/shogi-extend/spec/models/quick_script/dev/sleep_script.rb
# >> /Users/ikeda/src/shogi-extend/app/models/quick_script/dev/table_script.rb
# >> /Users/ikeda/src/shogi-extend/spec/models/quick_script/dev/table_script.rb
# >> /Users/ikeda/src/shogi-extend/app/models/quick_script/dev/value_script.rb
# >> /Users/ikeda/src/shogi-extend/spec/models/quick_script/dev/value_script.rb
# >> /Users/ikeda/src/shogi-extend/app/models/quick_script/exception_rescue_mod.rb
# >> /Users/ikeda/src/shogi-extend/spec/models/quick_script/exception_rescue_mod.rb
# >> /Users/ikeda/src/shogi-extend/app/models/quick_script/flash_mod.rb
# >> /Users/ikeda/src/shogi-extend/spec/models/quick_script/flash_mod.rb
# >> /Users/ikeda/src/shogi-extend/app/models/quick_script/form_mod.rb
# >> /Users/ikeda/src/shogi-extend/spec/models/quick_script/form_mod.rb
# >> /Users/ikeda/src/shogi-extend/app/models/quick_script/group1/hello_script.rb
# >> /Users/ikeda/src/shogi-extend/spec/models/quick_script/group1/hello_script.rb
# >> /Users/ikeda/src/shogi-extend/app/models/quick_script/helper_mod.rb
# >> /Users/ikeda/src/shogi-extend/spec/models/quick_script/helper_mod.rb
# >> /Users/ikeda/src/shogi-extend/app/models/quick_script/invisible_mod.rb
# >> /Users/ikeda/src/shogi-extend/spec/models/quick_script/invisible_mod.rb
# >> /Users/ikeda/src/shogi-extend/app/models/quick_script/layout_mod.rb
# >> /Users/ikeda/src/shogi-extend/spec/models/quick_script/layout_mod.rb
# >> /Users/ikeda/src/shogi-extend/app/models/quick_script/login_user_mod.rb
# >> /Users/ikeda/src/shogi-extend/spec/models/quick_script/login_user_mod.rb
# >> /Users/ikeda/src/shogi-extend/app/models/quick_script/main.rb
# >> /Users/ikeda/src/shogi-extend/spec/models/quick_script/main.rb
# >> /Users/ikeda/src/shogi-extend/app/models/quick_script/meta_mod.rb
# >> /Users/ikeda/src/shogi-extend/spec/models/quick_script/meta_mod.rb
# >> /Users/ikeda/src/shogi-extend/app/models/quick_script/order_mod.rb
# >> /Users/ikeda/src/shogi-extend/spec/models/quick_script/order_mod.rb
# >> /Users/ikeda/src/shogi-extend/app/models/quick_script/pagination_mod.rb
# >> /Users/ikeda/src/shogi-extend/spec/models/quick_script/pagination_mod.rb
# >> /Users/ikeda/src/shogi-extend/app/models/quick_script/process_type_mod.rb
# >> /Users/ikeda/src/shogi-extend/spec/models/quick_script/process_type_mod.rb
# >> /Users/ikeda/src/shogi-extend/app/models/quick_script/qs_group_info.rb
# >> /Users/ikeda/src/shogi-extend/spec/models/quick_script/qs_group_info.rb
# >> /Users/ikeda/src/shogi-extend/app/models/quick_script/redirect_mod.rb
# >> /Users/ikeda/src/shogi-extend/spec/models/quick_script/redirect_mod.rb
# >> /Users/ikeda/src/shogi-extend/app/models/quick_script/swars/ordered_index.rb
# >> /Users/ikeda/src/shogi-extend/spec/models/quick_script/swars/ordered_index.rb
# >> /Users/ikeda/src/shogi-extend/app/models/quick_script/swars/prison_all_script.rb
# >> /Users/ikeda/src/shogi-extend/spec/models/quick_script/swars/prison_all_script.rb
# >> /Users/ikeda/src/shogi-extend/app/models/quick_script/swars/prison_new_script.rb
# >> /Users/ikeda/src/shogi-extend/spec/models/quick_script/swars/prison_new_script.rb
# >> /Users/ikeda/src/shogi-extend/app/models/quick_script/swars/prison_search_script.rb
# >> /Users/ikeda/src/shogi-extend/spec/models/quick_script/swars/prison_search_script.rb
# >> /Users/ikeda/src/shogi-extend/app/models/quick_script/swars/pro_script.rb
# >> /Users/ikeda/src/shogi-extend/spec/models/quick_script/swars/pro_script.rb
# >> /Users/ikeda/src/shogi-extend/app/models/quick_script/swars/user_script.rb
# >> /Users/ikeda/src/shogi-extend/spec/models/quick_script/swars/user_script.rb
# >> /Users/ikeda/src/shogi-extend/app/models/quick_script/throttle_mod.rb
# >> /Users/ikeda/src/shogi-extend/spec/models/quick_script/throttle_mod.rb
