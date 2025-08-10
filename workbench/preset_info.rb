require "./setup"
PresetInfo.lookup("平手").db_record! # => #<Preset id: 1, key: "平手", position: 0, created_at: "2025-05-17 00:36:48.000000000 +0900", updated_at: "2025-05-17 00:36:48.000000000 +0900">
PresetInfo.lookup("二枚落ち")        # => <二枚落ち>
