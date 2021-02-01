require 'rails_helper'

RSpec.describe Api::Wkbk::BooksController, type: :controller do
  before(:context) do
    Actb.setup
    Emox.setup
    Wkbk.setup
    Wkbk::Book.mock_setup
    # tp Wkbk.info
    # tp Wkbk::Book
  end

  [
    { args: [ :index, params: {                                      }], code: 200, },
    { args: [ :show,  params: { book_id: 1,                          }], code: 200, },
    { args: [ :show,  params: { book_id: 2,                          }], code: 403, },
    { args: [ :show,  params: { book_id: 9999,                       }], code: 404, },
    { args: [ :edit,  params: { book_id: 2, _user_id: User.sysop.id, }], code: 200, },
    { args: [ :show,  params: { book_id: 4, _user_id: User.sysop.id, }], code: 403, },
    { args: [ :edit,  params: {                                      }], code: 403, },
    { args: [ :edit,  params: {             _user_id: User.sysop.id, }], code: 200, },
    { args: [ :edit,  params: { book_id: 1,                          }], code: 403, },
    { args: [ :edit,  params: { book_id: 2,                          }], code: 403, },
    { args: [ :edit,  params: { book_id: 3,                          }], code: 403, },
    { args: [ :edit,  params: { book_id: 4,                          }], code: 403, },
    { args: [ :edit,  params: { book_id: 1, _user_id: User.sysop.id, }], code: 200, },
    { args: [ :edit,  params: { book_id: 2, _user_id: User.sysop.id, }], code: 200, },
    { args: [ :edit,  params: { book_id: 3, _user_id: User.sysop.id, }], code: 404, },
    { args: [ :edit,  params: { book_id: 4, _user_id: User.sysop.id, }], code: 404, },
  ].each do |e|
    it "アクセス制限" do
      get *e[:args]
      expect(response).to have_http_status(e[:code])
    end
  end
end
