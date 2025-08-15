require "#{__dir__}/setup"
Ppl.setup_for_workbench

# ネットから
# Ppl::Updater.resume_crawling

# JSONから
rows = JSON.parse(Pathname("all.json").read, symbolize_names: true)
rows.each.with_index { |e, i| Ppl::Updater.update_raw(i, e) }
