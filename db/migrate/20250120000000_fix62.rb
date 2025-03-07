class Fix62 < ActiveRecord::Migration[6.0]
  def change
    if Rails.env.local?
    else
      QuickScript::Swars::TacticStatScript.primary_aggregate_call
    end
  end
end
