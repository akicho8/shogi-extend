#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

`rm -fr __tactic_infos`
Warabi::TacticInfo.all_elements.each do |e|
  record = General::Battle.tagged_with(e.name, on: "#{e.tactic_info.key}_tags").order(:turn_max).take
  if record
    if converted_info = record.converted_infos.text_format_eq(:kif).take
      file = Pathname("__tactic_infos/#{e.tactic_info.name}/#{e.name}.kif")
      FileUtils.makedirs(file.expand_path.dirname)
      file.write(converted_info.text_body)
    end
    puts "hit: #{e.name}"
  else
    # puts "skip: #{e.name}"
  end
end

# ssh s
# cd /var/www/shogi_web_production/current
# RAILS_ENV=production rails c
# 上のをコピペ
# rsync -avz s:/var/www/shogi_web_production/current/__tactic_infos/ ~/src/warabi/experiment/
# >> hit: 高美濃囲い
# >> hit: 銀冠穴熊
# >> hit: 横歩取り
# >> hit: 遠山流
# >> hit: 四間飛車
# >> hit: 対振り持久戦
