require "./setup"

User.delete_all
Wkbk.destroy_all
Wkbk.setup
User.setup

user = User.sysop
book = user.wkbk_books.create!(folder: user.wkbk_folder_for(:public))
article = user.wkbk_articles.create!(folder: user.wkbk_folder_for(:private))
book.articles << article







