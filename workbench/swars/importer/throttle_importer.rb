require "./setup"
Swars::Importer::ThrottleImporter.new(user_key: "bsplive").call
Swars::User["bsplive"].hard_crawled_at # => Wed, 27 Nov 2024 06:17:03.000000000 JST +09:00
