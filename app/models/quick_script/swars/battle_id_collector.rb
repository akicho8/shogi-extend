module QuickScript
  module Swars
    class BattleIdCollector
      def tactic_battle_ids_count(item)
        (tactic_battle_ids_hash[item.key] || []).size
      end

      # TODO: なんか変。レシーバ は BattleIdCollector ではなく TacticBattleMiningScript (BattleIdMining に定義) とするべきじゃないの？

      def tactic_battle_ids_hash
        @tactic_battle_ids_hash ||= TacticBattleMiningScript.new.aggregate || {}
      end

      def grade_battle_ids_hash
        @grade_battle_ids_hash ||= GradeBattleMiningScript.new.aggregate || {}
      end

      def preset_battle_ids_hash
        @preset_battle_ids_hash ||= PresetBattleMiningScript.new.aggregate || {}
      end

      def style_battle_ids_hash
        @style_battle_ids_hash ||= StyleBattleMiningScript.new.aggregate || {}
      end
    end
  end
end
