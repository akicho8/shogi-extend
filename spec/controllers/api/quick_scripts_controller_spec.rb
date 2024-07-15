require "rails_helper"

RSpec.describe Api::QuickScriptsController, type: :controller do
  it "中身は返さずOGP専用の情報を返す" do
    get :show, params: { qs_group_key: "chore", qs_page_key: "null", format: "json", __FOR_ASYNC_DATA__: "true"}
    hash = JSON.parse(response.body, symbolize_names: true)
    assert { hash[:title] }
    assert { hash[:description] }
    assert { response.status == 200 }
  end

  it "実行後の結果を返す" do
    get :show, params: { qs_group_key: "chore", qs_page_key: "null", format: "json" }
    hash = JSON.parse(response.body, symbolize_names: true)
    assert { hash.has_key?(:body) }
    assert { response.status == 200 }
  end

  describe "特定のグループに対しては即座にBASIC認証が出る" do
    it "dev" do
      get :show, params: { qs_group_key: "dev", qs_page_key: "__qs_page_key_is_blank__" }
      assert { response.status == 401 }
    end
    it "admin" do
      get :show, params: { qs_group_key: "admin", qs_page_key: "__qs_page_key_is_blank__" }
      assert { response.status == 401 }
    end
  end
end
