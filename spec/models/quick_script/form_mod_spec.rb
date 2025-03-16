require "rails_helper"

RSpec.describe QuickScript::FormMod, type: :model do
  it "submitted?" do
    object = QuickScript::Dev::NullScript.new(exec: "true")
    object.params_add_submit_key = :exec
    assert { object.submitted? }
  end

  it "#elsms_normalize" do
    instance = QuickScript::Chore::NullScript.new
    assert { instance.elsms_normalize(nil)                                                                                              == {} }
    assert { instance.elsms_normalize("a")                                                                                              == {:a=>{:el_label=>"a", :el_message=>nil}} }
    assert { instance.elsms_normalize([1, 2])                                                                                           == {:"1"=>{:el_label=>"1", :el_message=>nil}, :"2"=>{:el_label=>"2", :el_message=>nil}} }
    assert { instance.elsms_normalize([["a", "A"], ["b", "B"]])                                                                         == {:a=>{:el_label=>"A", :el_message=>nil}, :b=>{:el_label=>"B", :el_message=>nil}} }
    assert { instance.elsms_normalize(["a", "b"])                                                                                       == {:a=>{:el_label=>"a", :el_message=>nil}, :b=>{:el_label=>"b", :el_message=>nil}} }
    assert { instance.elsms_normalize({ "a" => "A", "b" => "B" })                                                                       == {:a=>{:el_label=>"A", :el_message=>nil}, :b=>{:el_label=>"B", :el_message=>nil}} }
    assert { instance.elsms_normalize({ "a" => { el_label: "A", el_message: "am" }, "b" => { el_label: "B", el_message: "bm" }, })      == {:a=>{:el_label=>"A", :el_message=>"am"}, :b=>{:el_label=>"B", :el_message=>"bm"}} }
    assert { instance.elsms_normalize([ { key: "a", el_label: "A", el_message: "am" }, { key: "b", el_label: "B", el_message: "bm" } ]) == {:a=>{:el_label=>"A", :el_message=>"am"}, :b=>{:el_label=>"B", :el_message=>"bm"}} }
  end
end
