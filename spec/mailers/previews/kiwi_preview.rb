# http://localhost:3000/rails/mailers/kiwi

class KiwiPreview < ActionMailer::Preview
  # http://localhost:3000/rails/mailers/kiwi/book_owner_message
  def book_owner_message
    KiwiMailer.book_owner_message(Kiwi::BookMessage.first)
  end

  # http://localhost:3000/rails/mailers/kiwi/book_other_message
  def book_other_message
    KiwiMailer.book_other_message(User.first, Kiwi::BookMessage.first)
  end

  # http://localhost:3000/rails/mailers/kiwi/lemon_notify
  def lemon_notify
    all_params = {
      :media_builder_params => {
        :recipe_key => "is_recipe_png",
      },
    }
    user1 = User.sysop
    free_battle1 = user1.free_battles.create!(kifu_body: "68S", use_key: "kiwi_lemon")
    lemon1 = user1.kiwi_lemons.create!(recordable: free_battle1, all_params: all_params)
    lemon1.main_process
    KiwiMailer.lemon_notify(lemon1)
  end
end
