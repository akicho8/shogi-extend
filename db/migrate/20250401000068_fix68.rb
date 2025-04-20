class Fix68 < ActiveRecord::Migration[6.0]
  def change
    if Rails.env.local?
    else
      QuickScript::Swars::TacticListScript.new.cache_write
    end
  end
end
