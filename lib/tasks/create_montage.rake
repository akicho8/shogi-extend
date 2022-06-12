desc "モンタージュ画像の生成"
task "my:create_montage" do
  if Pathname("doc/images").exist?
    system "montage -tile 2 -thumbnail 800x -geometry +0+0 doc/images/*.png doc/montage.png"
    system "montage -tile 3 -thumbnail 400x -geometry +0+0 doc/images/*.png doc/montage_for_doc.png"
    system "tree -N doc"
    system "ls -al doc/montage*"
    system "open doc/montage.png"
  end
end
