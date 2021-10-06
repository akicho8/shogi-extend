require "rails_helper"

RSpec.describe "動画作成", type: :system do
  include KiwiSupport

  before do
    Actb.setup
    Emox.setup
    Wkbk.setup

    login
    visit_app
  end

  it "トップ" do
    assert_text "動画作成"
    doc_image
  end

  it "動画ギャラリー" do
    visit "/video"
    assert_text "動画"
    doc_image
  end

  # cd ~/src/shogi-extend/ && BROWSER_DEBUG=1 rspec ~/src/shogi-extend/spec/system/kiwi_spec.rb -e 'トリム'
  describe "トリム" do
    # cd ~/src/shogi-extend/ && BROWSER_DEBUG=1 rspec ~/src/shogi-extend/spec/system/kiwi_spec.rb -e '空の場合'
    it "空の場合" do
      find(".any_source_trim_handle").click      # 「トリム」ボタンを押す
      assert_text("0手目から")
      modal_submit        # 「0手目から」を押す
      assert_text("0+0手目まで")
      modal_submit        # 「0+0手目まで」を押す
      modal_submit        # 「確定」を押す
      value = find(".body_field textarea").value # フォームに平手の SFEN が入っている
      assert { value == "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1" }
    end
    # cd ~/src/shogi-extend/ && BROWSER_DEBUG=1 rspec ~/src/shogi-extend/spec/system/kiwi_spec.rb -e '入力済みの場合'
    it "入力済みの場合" do
      find(".body_field textarea").set("position startpos moves 7g7f 8c8d 7i6h 3c3d 6h7g")
      find(".any_source_trim_handle").click      # 「トリム」ボタンを押す
      assert_text("0手目から")
      find(".button.next").click
      assert_text("1手目から")
      modal_submit
      assert_text("1+4手目")
      find(".button.previous").click
      assert_text("1+3手目")
      find(".button.previous").click
      assert_text("1+2手目")
      modal_submit
      modal_submit        # 「確定」を押す
      value = find(".body_field textarea").value # フォームに SFEN が入っている
      assert { value == "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/2P6/PP1PPPPPP/1B5R1/LNSGKGSNL w - 1 moves 8c8d 7i6h" }
    end
  end

  def modal_submit
    find(".modal .submit_handle").click
  end

  def visit_app(args = {})
    args = args.merge({
        :__debug_box_skip__                => "true",
        :__color_theme_key_dropdown_skip__ => "true", # 色テーマ画像を作り直してしまうためスキップする
      })
    visit "/video/new?#{args.to_query}"
  end
end
