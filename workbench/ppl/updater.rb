require "#{__dir__}/setup"
Ppl.setup_for_workbench

# ネット → DB
# Ppl::Updater.resume_crawling

# ネット → JSON生成
# Ppl::Updater.json_write

# JSON → DB
Ppl::Updater.import_from_json

# rows = Ppl::AntiquitySpider.new("S49", take_size: nil, verbose: false, sleep: 0, mock: true).call
# Ppl::SeasonKeyVo["S49"].update_by_records(rows)

# Ppl::Updater.resume_crawling(start: "S62", limit: 2)
# Ppl::Updater.resume_crawling(start: "30",  limit: 2)
# Ppl::Updater.resume_crawling(start: "S49", limit: 2)

Ppl::Updater.latest_key         # => "S49"
Ppl::Season.count               # => 0
Ppl::User.count                 # => 0
Ppl::Membership.count           # => 0
