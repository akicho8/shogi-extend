# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 設定 (xsettings as Xsetting)
#
# |------------+----------+-------------+-------------+------+-------|
# | name       | desc     | type        | opts        | refs | index |
# |------------+----------+-------------+-------------+------+-------|
# | id         | ID       | integer(8)  | NOT NULL PK |      |       |
# | var_key    | 変数名   | string(255) | NOT NULL    |      | A!    |
# | var_value  | 変数値   | text(65535) |             |      |       |
# | created_at | 作成日時 | datetime    | NOT NULL    |      |       |
# | updated_at | 更新日時 | datetime    | NOT NULL    |      |       |
# |------------+----------+-------------+-------------+------+-------|

require "rails_helper"

RSpec.describe Xsetting, type: :model do
  before do
    # DBは自動的に消されるのであとはキャッシュを意図的に削除すれば完全に最初の状態になる
    Xsetting.ds_cache_clear
  end

  it "参照と設定 class accessor" do
    # 参照しただけなのでDBには入っていない
    Xsetting[:t_string_var].should == "(t_string_var.default)"
    Xsetting.stored_var_keys.should == []

    # 初期値とは異なる値を設定したのでDBに入った
    Xsetting[:t_string_var] = "異なる値"
    Xsetting.stored_var_keys.should == [:t_string_var]

    # さらに初期値と異なる値を設定してDBの値が変わる
    Xsetting[:t_string_var] = "さらに異なる値"
    Xsetting.stored_var_keys.should == [:t_string_var]
    Xsetting[:t_string_var].should == "さらに異なる値"
  end

  it "var_set は []= と同じなのでDBは変化しない" do
    Xsetting.var_set(:t_string_var, Xsetting[:t_string_var])
    Xsetting.stored_var_keys.should == []
  end

  it "値が同じだけど var_set に :force => true を使えば入れれる" do
    Xsetting.var_set(:t_string_var, Xsetting[:t_string_var], :force => true)
    Xsetting.stored_var_keys.should == [:t_string_var]
  end

  it "自分の型に変換される integer" do
    Xsetting[:t_integer_var].should == 1
    Xsetting[:t_integer_var] = "2"
    Xsetting[:t_integer_var].should == 2
  end

  def assert_type_convertion(var_key, values)
    after_vlaues = values.collect{|a, b|
      Xsetting[var_key] = a
      [a, Xsetting[var_key]]
    }
    after_vlaues.should == values
  end

  it "取得値チェック" do
    assert_type_convertion(:t_string_var,  [[1,  "1"], ["str", "str"], [0.5,  "0.5"], [true, "true"], [false, "false"], [nil, nil], ["2000-01-01 01:02:03", "2000-01-01 01:02:03"]])
    assert_type_convertion(:t_text_var,    [[1,  "1"], ["str", "str"], [0.5,  "0.5"], [true, "true"], [false, "false"], [nil, nil], ["2000-01-01 01:02:03", "2000-01-01 01:02:03"]])
    assert_type_convertion(:t_symbol_var,  [[1, :"1"], ["str",  :str], [0.5, :"0.5"], [true,  :true], [false,  :false], [nil, nil], ["2000-01-01 01:02:03", :"2000-01-01 01:02:03"]])
    assert_type_convertion(:t_integer_var, [[1,    1], ["str",     0], [0.5,      0], [true,      0], [false,       0], [nil, nil], ["2000-01-01 01:02:03", 2000]])
    assert_type_convertion(:t_float_var,   [[1,    1], ["str",     0], [0.5,    0.5], [true,    0.0], [false,     0.0], [nil, nil], ["2000-01-01 01:02:03", 2000.0]])
    assert_type_convertion(:t_boolean_var, [[1, true], ["str",  true], [0.5,   true], [true,   true], [false,   false], [nil, nil], ["2000-01-01 01:02:03", true]])
    assert_type_convertion(:t_datetime_var,[[1, nil],  ["str",   nil], [0.5,    nil], [true,    nil], [false,     nil], [nil, nil], ["2000-01-01 01:02:03", Time.zone.parse("2000-01-01 01:02:03")]])
    assert_type_convertion(:t_date_var,    [[1,  nil], ["str",   nil], [0.5,    nil], [true,    nil], [false,     nil], [nil, nil], ["2000-01-01 01:02:03", Date.parse("2000-01-01")]])
  end

  it "登録済みの変数を元に戻す class reset" do
    Xsetting[:t_string_var] = "changed"
    Xsetting.reset(:t_string_var)
    Xsetting[:t_string_var].should == "(t_string_var.default)"
  end

  it "登録済みの変数を元に戻す class reset_all" do
    Xsetting[:t_string_var] = "changed"
    Xsetting.reset_all
    Xsetting[:t_string_var].should == "(t_string_var.default)"
  end

  it "更新されてDBに入っている変数名一覧を取得できる class stored_var_keys" do
    Xsetting.stored_var_keys.should == []
    Xsetting[:t_string_var] = "changed"
    Xsetting.stored_var_keys.should == [:t_string_var]
  end

  it "すべてをDBに入れる class store_all" do
    Xsetting.destroy_all
    Xsetting.store_all
    Xsetting.count.should == AvailableXsetting.count
  end

  it "使ってない設定は削除される class undefined_remove" do
    # 2件変更して2件DBに入る
    Xsetting.var_set(:t_string_var, "changed", :force => true)
    Xsetting.var_set(:t_integer_var, "9", :force => true)
    Xsetting.count.should == 2

    begin
      AvailableXsetting.memory_record_reset(AvailableXsetting.app_data.reject{|e|e[:key] == :t_integer_var})
      proc {
        Xsetting.undefined_remove         # ので1件削除される
      }.should change(Xsetting, :count).by(-1)
    ensure
      AvailableXsetting.memory_record_reset(AvailableXsetting.app_data)
    end
  end
end
