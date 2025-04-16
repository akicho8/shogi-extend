require "rails_helper"

RSpec.describe QuickScript::Swars::BattleDownloadScript::ZipBuilder, type: :model do
  def case1(**params)
    ::Swars::Battle.destroy_all
    @current_user = User.create!
    swars_user = ::Swars::User.find_or_create_by!(key: "SWARS_USER_KEY")
    ::Swars::Battle.create! do |e|
      e.memberships.build(user: swars_user)
    end
    params = { query: "SWARS_USER_KEY", **params }
    options = { current_user: @current_user }
    instance = QuickScript::Swars::BattleDownloadScript.new(params, options)
    blob = instance.zip_builder.to_blob
    Zip::InputStream.open(blob) do |zis|
      entry = zis.get_next_entry
      bin = zis.read
      {
        :path       => entry.name,
        :encode_key => NKF.guess(bin).to_s,
      }
    end
  end

  it "フォーマット" do
    assert { case1(format_key: :kif)[:path] == "SWARS_USER_KEY/alice-bob-20000101_000000.kif"  }
    assert { case1(format_key: :ki2)[:path] == "SWARS_USER_KEY/alice-bob-20000101_000000.ki2"  }
    assert { case1(format_key: :csa)[:path] == "SWARS_USER_KEY/alice-bob-20000101_000000.csa"  }
    assert { case1(format_key: :sfen)[:path] == "SWARS_USER_KEY/alice-bob-20000101_000000.sfen" }
  end

  it "文字コード" do
    assert { case1(encode_key: "UTF-8")[:encode_key] == "UTF-8"     }
    assert { case1(encode_key: "Shift_JIS")[:encode_key] == "Shift_JIS" }
  end

  it "ZIPの構造" do
    assert { case1(structure_key: :flat)[:path] == "SWARS_USER_KEY/alice-bob-20000101_000000.kif"           }
    assert { case1(structure_key: :day)[:path] == "SWARS_USER_KEY/2000-01-01/alice-bob-20000101_000000.kif" }
    assert { case1(structure_key: :month)[:path] == "SWARS_USER_KEY/2000-01/alice-bob-20000101_000000.kif"  }
  end
end
