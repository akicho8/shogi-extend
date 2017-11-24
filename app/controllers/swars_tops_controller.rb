class SwarsTopsController < ApplicationController
  def show
    # BattleUser.destroy_all
    # BattleRecord.destroy_all

    if current_user_key
      GameTypeInfo.each do |e|
        torikomu(gtype: e.swars_key)
      end
      @battle_user = BattleUser.find_by(user_key: current_user_key)
    end
  end

  def torikomu(**params)
    shogi_wars_cop = ShogiWarsCop.new
    list = shogi_wars_cop.battle_list_get({user_key: current_user_key}.merge(params))
    list.each do |history|
      unless BattleRecord.where(battle_key: history[:battle_key]).exists?
        info = shogi_wars_cop.battle_one_info_get(history[:battle_key])

        # 対局中だった場合
        unless info[:battle_done]
          next
        end

        battle_users = history[:users].collect do |e|
          battle_user = BattleUser.find_or_initialize_by(user_key: e[:user_key])
          battle_user_rank = BattleUserRank.find_by!(unique_key: e[:rank])
          battle_user.update!(battle_user_rank: battle_user_rank) # 常にランクを更新する
          battle_user
        end

        battle_record = BattleRecord.new
        battle_record.attributes = {
          battle_key: history[:battle_key],
          game_type_key: info.dig(:meta, :gtype),
          csa_hands: info[:csa_hands],
        }

        history[:users].each do |e|
          battle_user = BattleUser.find_by!(user_key: e[:user_key])
          battle_user_rank = BattleUserRank.find_by!(unique_key: e[:rank])
          battle_record.battle_ships.build(battle_user:  battle_user, battle_user_rank: battle_user_rank)
        end

        battle_record.save!
      end
    end
  end

  def current_user_key
    if Rails.env.development?
      # params[:user_key] = "hanairobiyori"
    end
    params[:user_key].to_s.gsub(/\p{blank}/, " ").strip.presence
  end

  rescue_from "Mechanize::ResponseCodeError" do |exception|
    notify_airbrake(exception)
    flash.now[:alert] = "#{exception.class.name}: #{exception.message}"
    render :show
  end
end
