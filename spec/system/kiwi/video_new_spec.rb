require "rails_helper"

RSpec.describe "動画作成", type: :system, kiwi: true do
  before do
    login
    visit_app
  end

  it "トップ" do
    assert_text "動画作成"
  end

  it "動画ライブラリ" do
    visit_to "/video"
    assert_text "動画"
  end

  describe "トリム" do
    it "空の場合" do
      find(".body_field textarea").set("手合割：平手")
      find(".any_source_trim_handle").click      # 「トリム」ボタンを押す
      assert_selector(:button, "0手目から")
      modal_apply        # 「0手目から」を押す
      assert_selector(:button, "0+0手目まで")
      modal_apply        # 「0+0手目まで」を押す
      modal_apply        # 「確定」を押す
      value = find(".body_field textarea").value # フォームに平手の SFEN が入っている
      assert { value == "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1" }
    end
    it "入力済みの場合" do
      find(".body_field textarea").set("position startpos moves 7g7f 8c8d 7i6h 3c3d 6h7g")
      find(".any_source_trim_handle").click      # 「トリム」ボタンを押す
      assert_selector(:button, "0手目から")
      find(".button.next").click
      assert_selector(:button, "1手目から")
      modal_apply
      assert_selector(:button, "1+4手目")
      find(".button.previous").click
      assert_selector(:button, "1+3手目")
      find(".button.previous").click
      assert_selector(:button, "1+2手目")
      modal_apply
      modal_apply        # 「確定」を押す
      value = find(".body_field textarea").value # フォームに SFEN が入っている
      assert { value == "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/2P6/PP1PPPPPP/1B5R1/LNSGKGSNL w - 1 moves 8c8d 7i6h" }
    end
  end

  def modal_apply
    find(".modal .apply_handle").click
  end

  def visit_app(params = {})
    visit_to("/video/new", params.merge({
          :__color_theme_key_dropdown_skip__ => true, # 色テーマ画像を作り直してしまうためスキップする
        }))
  end
end
