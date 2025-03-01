require "./setup"
# Swars::Importer::FullHistoryImporter.new(user_key: "bsplive").call
# Swars::User["bsplive"].hard_crawled_at # => Tue, 26 Nov 2024 18:17:42.000000000 JST +09:00

# Swars::Importer::FullHistoryImporter.new(user_key: "th_1230", remote_run: true, look_up_to_page_x: 1).call
# Swars::User["th_1230"].hard_crawled_at # => Wed, 27 Nov 2024 07:43:49.000000000 JST +09:00

# Swars::Importer::FullHistoryImporter.new(user_key: "yukky1119", remote_run: true, look_up_to_page_x: 1).call
# Swars::User["yukky1119"].hard_crawled_at # => Sun, 24 Nov 2024 14:14:45.000000000 JST +09:00

# Swars::Importer::FullHistoryImporter.new(user_key: "slowstep3210", remote_run: true, look_up_to_page_x: 1).call
# Swars::User["slowstep3210"].hard_crawled_at # => Sun, 24 Nov 2024 01:26:58.000000000 JST +09:00

Swars::Importer::SingleHistoryImporter.new(user_key: "akihiko810", remote_run: true, look_up_to_page_x: 1).call
Swars::User["akihiko810"].hard_crawled_at # => Sat, 23 Nov 2024 01:12:46.000000000 JST +09:00

# tp Swars::User["asa2yoru"].battles.last(10).collect(&:info)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?page=1&user_id=akihiko810
# >> akihiko810 Page1 ルール未指定 [全10件][新0件][続く]
