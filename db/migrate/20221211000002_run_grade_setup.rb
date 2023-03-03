class RunGradeSetup < ActiveRecord::Migration[5.1]
  def up
    Swars::Grade.setup
  end
end
