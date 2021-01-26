class Refactor1 < ActiveRecord::Migration[6.0]
  def change
    Actb::Lineage.lookup("玉方持駒限定の似非詰将棋")&.update!(key: "玉方持駒限定詰将棋") rescue nil
  end
end
