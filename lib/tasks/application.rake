desc "モンタージュ画像の生成"
task :create_montage do
  `montage -tile 2 -thumbnail 800x -geometry +0+0 doc/images/*.png montage.png`
  `montage -tile 1 -thumbnail 800x -geometry +0+0 doc/images/*.png montage_one_row.png`
  system "tree -N doc"
  system "ls -al montage*"
  system "open montage.png"
end
