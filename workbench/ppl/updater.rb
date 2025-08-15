require "#{__dir__}/setup"
Ppl.setup_for_workbench

# ネットからDB
#  Ppl::Updater.resume_crawling

# ネットからJSON
# all = (28..77).collect { |e| Ppl::Spider.new(season_number: e).call }
# Pathname("all.json").write(all.to_json)

# JSONからDB
rows = JSON.parse(Pathname("all.json").read, symbolize_names: true)
rows.each.with_index { |e, i| Ppl::Updater.update_raw(i, e) }
