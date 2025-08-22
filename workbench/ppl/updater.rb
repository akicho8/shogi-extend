require "#{__dir__}/setup"
Ppl.setup_for_workbench

# ネット → DB
# Ppl::Updater.resume_crawling

# ネット → JSON生成
# a = (1..30).collect { |e| Ppl::UnofficialSpider.new(season_number: e, validate: true).call }
# b = (31..77).collect { |e| Ppl::OfficialSpider.new(season_number: e, validate: false).call }
# Pathname("all.json").write((a + b).to_json)

# JSON → DB
rows = JSON.parse(Pathname("all.json").read, symbolize_names: true)
rows.each.with_index(1) { |e, i| Ppl::Updater.update_raw(i, e) }
