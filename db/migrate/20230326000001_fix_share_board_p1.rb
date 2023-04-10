class FixShareBoardP1 < ActiveRecord::Migration[5.1]
  def up
    ShareBoard::Battle.all.each do |battle|
      membership = battle.memberships.find_by!(judge: Judge.fetch(:win))
      battle.win_location = membership.location
      battle.save!
    end
    tp ShareBoard::Battle
  end
end
