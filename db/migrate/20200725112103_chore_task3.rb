class ChoreTask3 < ActiveRecord::Migration[6.0]
  def up
    change_table :actb_moves_answers do |t|
      t.string :moves_human_str, null: true, index: false, comment: "人間向け指し手"
    end

    # Actb::Question.reset_column_information
    # Actb::Question.find_each do |e|
    #   e.moves_answers.each do |e|
    #     e.send(:attribute_will_change!, :moves_str)
    #     begin
    #       e.save!(touch: false)
    #     rescue => error
    #       p ["#{__FILE__}:#{__LINE__}", __method__, error.message.lines.first.strip, e.question.id, e.id]
    #     end
    #   end
    # end
  end
end
