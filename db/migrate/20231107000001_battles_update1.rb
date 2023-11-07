class BattlesUpdate1 < ActiveRecord::Migration[6.0]
  def up
    [
      "BOUYATETSU5",
      "bsplive",
    ].each do |key|
      if user = Swars::User.find_by(key: key)
        user.battles.in_batches.each_record do |e|
          e.remake rescue nil
        end
      end
    end
  end
end
