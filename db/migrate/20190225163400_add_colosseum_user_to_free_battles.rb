# frozen_string_literal: true

class AddColosseumUserToFreeBattles < ActiveRecord::Migration[5.2]
  def change
    change_table :free_battles do |t|
      t.belongs_to :colosseum_user, null: true, index: true
      t.string :title
    end
  end
end
