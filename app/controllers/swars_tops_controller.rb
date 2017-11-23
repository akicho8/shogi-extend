class SwarsTopsController < ApplicationController
  def show
    # BattleUser.destroy_all
    # BattleRecord.destroy_all

    if current_user_key
      unless BattleUser.find_by(user_key: current_user_key)
        shogi_wars_cop = ShogiWarsCop.new
        list = shogi_wars_cop.battle_list_get(user_key: current_user_key)
        list.each do |history_one|
          unless BattleRecord.where(battle_key: history_one[:battle_key]).exists?
            info = shogi_wars_cop.battle_one_info_get(history_one[:battle_key])

            # raise info.inspect
            # {:battle_key=>"pleasure-hanairobiyori-20171122_224833", :url=>"http://kif-pona.heroz.jp/games/pleasure-hanairobiyori-20171122_224833", :meta=>{"name"=>"pleasure-hanairobiyori-20171122_224833", "avatar0"=>"_e1408s5hifumi", "avatar1"=>"_e1708s4c", "dan0"=>"1級", "dan1"=>"1級", "gtype"=>""}, :csa_hands=>"+7776FU,-3142GI,+2726FU,-5354FU,+2625FU,-4253GI,+2524FU,-2324FU,+2824HI,-4132KI,+0023FU,-2231KA,+6978KI,-5344GI,+4958KI,-1314FU,+3948GI,-8384FU,+7968GI,-8485FU,+6877GI,-7162GI,+6766FU,-5141OU,+5969OU,-6253GI,+8879KA,-4445GI,+5867KI,-4534GI,+5756FU,-3423GI,+2428HI,-0024FU,+3736FU,-3142KA,+4837GI,-4131OU,+3726GI,-5344GI,+7968KA,-3334FU,+6979OU,-4433GI,+7988OU,-3122OU,+9796FU,-9394FU,+2937KE,-4264KA,+4746FU,-7374FU,+6665FU,-6442KA,+2858HI,-7475FU,+5655FU,-5455FU,+5855HI,-7576FU,+6776KI,-0075FU,+7666KI,-3344GI,+5558HI,-8173KE,+0054FU,-6152KI,+4645FU,-4433GI,+0074FU,-7576FU,+6676KI,-0072FU,+6846KA,-8283HI,+7473TO,-8373HI,+4673UM,-7273FU,+0082HI,-5251KI,+5453TO,-0047KA,+5857HI,-4736UM,+5342TO,-5142KI,+5751RY,-3626UM,+0025FU,-2637UM,+2524FU,-2324GI,+0054KE,-0053GI,+5442NK,-5342GI,+5161RY,-3719UM,+8281RY,-0031KY,+0041KI,-7374FU,+0053FU,-4253GI,+4131KI,-5342GI,+3132KI,-2232OU,+6121RY"}

            battle_users = history_one[:users].collect do |e|
              battle_user = BattleUser.find_or_initialize_by(user_key: e[:user_key])
              battle_user_rank = BattleUserRank.find_by!(unique_key: e[:rank])
              battle_user.update!(battle_user_rank: battle_user_rank) # 常にランクを更新する
              battle_user
            end

            battle_record = BattleRecord.new
            battle_record.attributes = {
              battle_key: history_one[:battle_key],
              game_type_key: info[:meta][:gtype],
              csa_hands: info[:csa_hands],
            }

            history_one[:users].each do |e|
              battle_user = BattleUser.find_by!(user_key: e[:user_key])
              battle_user_rank = BattleUserRank.find_by!(unique_key: e[:rank])
              battle_record.battle_ships.build(battle_user:  battle_user, battle_user_rank: battle_user_rank)
            end

            battle_record.save!
          end
        end
      end

      @battle_user = BattleUser.find_by(user_key: current_user_key)
    end
  end

  def current_user_key
    params[:user_key] = "hanairobiyori"
    params[:user_key].presence
  end
end
