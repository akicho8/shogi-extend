#!/usr/bin/env ruby
require File.expand_path('../../../config/environment', __FILE__)

history_result = Swars::Agent::History.new(remote_run: true, user_key: "Jpriglim", page_index: 0).fetch
tp history_result.all_keys
# >> |--------------------------------------|
# >> | cadenacchi-Jpriglim-20230103_171144  |
# >> | Jpriglim-mitsuisan-20230103_165411   |
# >> | Jpriglim-masa0845-20230103_154444    |
# >> | kazune_to-Jpriglim-20230103_140622   |
# >> | Jpriglim-ThomasNobuo-20230103_134734 |
# >> | Jpriglim-yurippe-20230103_133117     |
# >> | Jpriglim-kazuyama777-20230103_132606 |
# >> | Jpriglim-Sbpsh41-20230103_125817     |
# >> | Jpriglim-iwaei-20230103_111635       |
# >> | jabikun-Jpriglim-20230103_105913     |
# >> |--------------------------------------|
