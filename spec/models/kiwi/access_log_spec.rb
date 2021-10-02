require "rails_helper"

module Kiwi
  RSpec.describe AccessLog, type: :model do
    include KiwiSupport

    before do
      Folder.setup
    end

    it "ログインユーザーのアクセス" do
      assert { access_log1.user }
      assert { access_log1.book }

      assert { access_log1.user.kiwi_access_logs == [access_log1] }
      assert { access_log1.user.kiwi_access_books == [book1]      }
      assert { access_log1.user.kiwi_access_logs.foobar123 == [book1] }

      assert { access_log1.book.access_logs == [access_log1]      }
      assert { access_log1.book.access_logs_count == 1            }
      assert { access_log1.book.access_log_users == [user1]       }

      assert { access_log1.book.access_logs == [access_log1]      }
      assert { access_log1.book.access_log_users == [user1]       }
    end

    it "非ログインユーザーのアクセス" do
      assert { access_log1 = book1.access_logs.create! }
    end
  end
end
