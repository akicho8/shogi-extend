class SwarsBattleRecordAccessLog < ApplicationRecord
  belongs_to :swars_battle_record, counter_cache: true, touch: :last_accessd_at
end
