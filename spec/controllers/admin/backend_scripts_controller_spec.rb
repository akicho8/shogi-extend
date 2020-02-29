require 'rails_helper'

RSpec.describe Admin::BackendScriptsController, type: :controller do
  it "ログイン必須になっている" do
    assert { Admin::BackendScriptsController.ancestors.include?(Admin::ApplicationController) }
  end
end
