desc "モンタージュ画像の生成"
task :create_montage do
  `montage -tile 3 -thumbnail 400x -geometry +0+0 doc/images/*.png montage.png`
  `montage -tile 1 -thumbnail 800x -geometry +0+0 doc/images/*.png montage_one_row.png`
  system "tree -N doc"
end
