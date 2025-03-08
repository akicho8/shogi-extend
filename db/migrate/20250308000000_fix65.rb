class Fix65 < ActiveRecord::Migration[6.0]
  def change
    QuickScript::Swars::BasicStatScript.new.cache_all
  end
end
