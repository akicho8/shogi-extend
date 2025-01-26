class Fix64 < ActiveRecord::Migration[6.0]
  def change
    Swars::Xmode.setup
  end
end
