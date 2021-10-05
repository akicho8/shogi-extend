module KiwiSupport
  extend ActiveSupport::Concern

  included do
    include ActiveJob::TestHelper # for perform_enqueued_jobs

    before do
      Actb.setup
      Emox.setup
      Wkbk.setup
      Kiwi::Folder.setup
    end

    let(:user1) { User.create!(name: "user1", email: "user1@localhost", confirmed_at: Time.current) }
    let(:user2) { User.create!(name: "user2", email: "user2@localhost", confirmed_at: Time.current) }
    let(:user3) { User.create!(name: "user3", email: "user3@localhost", confirmed_at: Time.current) }

    let(:mp4_params1) { Kiwi::Lemon::PARAMS_EXAMPLE_MP4 }
    let(:gif_params1) { Kiwi::Lemon::PARAMS_EXAMPLE_GIF }

    let(:free_battle1) do
      user1.free_battles.create!(kifu_body: mp4_params1[:body], use_key: "kiwi_lemon")
    end

    let(:lemon1) do
      user1.kiwi_lemons.create!(recordable: free_battle1, all_params: mp4_params1[:all_params])
    end

    let(:book1) do
      user1.kiwi_books.create!(lemon: lemon1, title: "アヒル", description: "(description)", folder_key: "public", tag_list: ["a", "b"])
    end

    let(:book_message1) do
      user1.kiwi_book_message_speak(book1, "(message1)")
    end

    let(:access_log1) do
      book1.access_logs.create!(user: user1)
    end
  end
end
