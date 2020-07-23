class TableRefactor12 < ActiveRecord::Migration[6.0]
  def up
    Actb::SourceAbout.reset_column_information
    Actb::Question.reset_column_information

    Actb::SourceAbout.setup
    Actb::Question.find_each do |e|
      if e.source_author.to_s.match(/不詳|不明/)
        e.source_author = nil
        e.source_about_key = "unknown"
      else
        e.source_about_key = "ascertained"
      end
      e.save!(touch: false)
      p ["#{__FILE__}:#{__LINE__}", __method__, e.id]
    end
  end
end
