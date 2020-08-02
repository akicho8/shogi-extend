class ChoreTask9 < ActiveRecord::Migration[6.0]
  def up
    if r = Actb::Lineage.lookup("詰将棋(玉方持駒限定)")
      r.update!(key: "玉方持駒限定の似非詰将棋")
    end
  end
end
