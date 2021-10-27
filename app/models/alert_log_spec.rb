# == Schema Information ==
#
# アラートログテーブル (alert_logs)
#
# +--------------+--------------+----------------+-------------+-----------------------+-------+
# | カラム名     | 意味         | タイプ         | 属性        | 参照                  | INDEX |
# +--------------+--------------+----------------+-------------+-----------------------+-------+
# | id           | ID           | integer(4)     | NOT NULL PK |                       |       |
# | target_id    | 対象ID       | integer(4)     |             | => (target_type)#id   | A     |
# | target_type  | 対象タイプ   | string(255)    |             | モデル名(polymorphic) | A     |
# | partner_id   | 相棒ID       | integer(4)     |             | => (partner_type)#id  | B     |
# | partner_type | 相棒タイプ   | string(255)    |             | モデル名(polymorphic) | B     |
# | level_code   | Level code   | integer(4)     | NOT NULL    |                       | C     |
# | subject      | 題名         | string(255)    |             |                       |       |
# | free_columns | Free columns | text => Hash   |             |                       |       |
# | created_at   | 作成日時     | datetime       | NOT NULL    |                       |       |
# | updated_at   | 更新日時     | datetime       | NOT NULL    |                       |       |
# | body         | 本文         | text(16777215) |             |                       |       |
# +--------------+--------------+----------------+-------------+-----------------------+-------+

require 'rails_helper'

RSpec.describe AlertLog, type: :model do
  let(:instance) {FactoryGirl.create(:alert_log)}
  let(:user) { FactoryGirl.create(:user) }
  let(:_default_attrs) {
    FactoryGirl.attributes_for(:alert_log)
  }

  it "バリデーションが正しい" do
    instance.valid?
    instance.errors.to_hash.should == {}
  end

  context "作成系" do
    it "作成できる" do
      alert_log = described_class.create(_default_attrs)
      alert_log.errors.to_hash.should == {}
    end
  end

  context "更新系" do
    it "更新できる" do
      instance.update(_default_attrs)
      instance.errors.to_hash.should == {}
    end
  end

  context "削除系" do
    before {instance}
    it "削除できる" do
      proc {
        instance.destroy
      }.should change(described_class, :count).by(-1)
    end
  end

  context "アプリ依存のインタフェース" do
    it "汎用" do
      record = AlertLog.track("xxx")
      record.subject.should == "xxx"
    end
  end

  context "メール通知対応" do
    it do
      proc { AlertLog.track("ok") }.should change(ActionMailer::Base.deliveries, :size).by(0)
    end
    it do
      proc { AlertLog.track("ok", :mail_notify => true) }.should change(ActionMailer::Base.deliveries, :size).by(1)
    end
    it "toオプション" do
      AlertLog.track("ok", :to => "xxx@xxx", :mail_notify => true)
      mail = ActionMailer::Base.deliveries.last
      mail.to.should == ["xxx@xxx"]
    end
  end
end
