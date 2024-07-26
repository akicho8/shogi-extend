require "./setup"
# QuickScript::Dispatcher.dispatch(qs_group_key: "dev", qs_page_key: "foo-bar-baz") # => #<QuickScript::Dev::FooBarBazScript:0x000000010c8fe460 @params={:qs_group_key=>"dev", :qs_page_key=>"foo_bar_baz"}, @options={}>
# QuickScript::Dispatcher.dispatch(qs_group_key: "dev", qs_page_key: "foo_bar_baz") # => #<QuickScript::Dev::FooBarBazScript:0x000000010cc7e2e8 @params={:qs_group_key=>"dev", :qs_page_key=>"foo_bar_baz"}, @options={}>
# tp QuickScript::Dispatcher.info

tp QuickScript::Dispatcher.all
tp QuickScript::Base.deep_subclasses
# >> [QuickScript::About::CreditScript, nil]
# >> [QuickScript::About::PrivacyPolicyScript, nil]
# >> [QuickScript::About::TermsScript, nil]
# >> [QuickScript::Account::DestroyScript, nil]
# >> [QuickScript::Account::EmailEditScript, nil]
# >> [QuickScript::Account::InfoScript, nil]
# >> [QuickScript::Account::KentoProDestroyScript, nil]
# >> [QuickScript::Account::LogoutScript, nil]
# >> [QuickScript::Account::NameEditScript, nil]
# >> [QuickScript::Account::ProfileImageUploadScript, nil]
# >> [QuickScript::Account::SnsAccountIntegrationScript, nil]
# >> [QuickScript::Admin::LoginScript, nil]
# >> [QuickScript::Admin::SwarsAgentScript, nil]
# >> [QuickScript::Chore::DocumentationScript, nil]
# >> [QuickScript::Chore::GroupScript, nil]
# >> [QuickScript::Chore::IndexScript, nil]
# >> [QuickScript::Chore::InvisibleScript, nil]
# >> [QuickScript::Chore::MarkdownScript, nil]
# >> [QuickScript::Chore::MessageScript, nil]
# >> [QuickScript::Chore::NotFoundScript, nil]
# >> [QuickScript::Chore::NullScript, nil]
# >> [QuickScript::Chore::StatusCodeScript, nil]
# >> [QuickScript::Dev::BackgroundJobScript, nil]
# >> [QuickScript::Dev::CalcScript, nil]
# >> [QuickScript::Dev::CsvDownloadGetScript, nil]
# >> [QuickScript::Dev::CsvDownloadPostScript, nil]
# >> [QuickScript::Dev::DelegateScript, nil]
# >> [QuickScript::Dev::EmojiScript, nil]
# >> [QuickScript::Dev::ErrorScript, nil]
# >> [QuickScript::Dev::Fake500Script, nil]
# >> [QuickScript::Dev::FetchIndexScript, nil]
# >> [QuickScript::Dev::FlashScript, nil]
# >> [QuickScript::Dev::FooBarBazScript, nil]
# >> [QuickScript::Dev::FormScript, nil]
# >> [QuickScript::Dev::HelloScript, nil]
# >> [QuickScript::Dev::HtmlScript, nil]
# >> [QuickScript::Dev::InvalidateBasicAuthScript, nil]
# >> [QuickScript::Dev::InvisibleScript, nil]
# >> [QuickScript::Dev::LoginRequired1Script, nil]
# >> [QuickScript::Dev::LoginRequired2Script, nil]
# >> [QuickScript::Dev::MarkdownScript, nil]
# >> [QuickScript::Dev::NavibarFalseScript, nil]
# >> [QuickScript::Dev::NullScript, nil]
# >> [QuickScript::Dev::PageReloadScript, nil]
# >> [QuickScript::Dev::PiyoShogiConfigComponentScript, nil]
# >> [QuickScript::Dev::Post1Script, nil]
# >> [QuickScript::Dev::Post2FormCounterScript, nil]
# >> [QuickScript::Dev::Post3SessionCounterScript, nil]
# >> [QuickScript::Dev::PostAndRedirectScript, nil]
# >> [QuickScript::Dev::Redirect1Script, nil]
# >> [QuickScript::Dev::Redirect2Script, nil]
# >> [QuickScript::Dev::Redirect3Script, nil]
# >> [QuickScript::Dev::SessionCounterScript, nil]
# >> [QuickScript::Dev::SessionScript, nil]
# >> [QuickScript::Dev::SheetScript, nil]
# >> [QuickScript::Dev::SidebarScript, nil]
# >> [QuickScript::Dev::SleepScript, nil]
# >> [QuickScript::Dev::StatusCodeTesterScript, nil]
# >> [QuickScript::Dev::TableScript, nil]
# >> [QuickScript::Dev::UrlHelpersScript, nil]
# >> [QuickScript::Dev::ValueScript, nil]
# >> [QuickScript::Dev::ZipDownloadPostScript, nil]
# >> [QuickScript::Group1::HelloScript, nil]
# >> [QuickScript::Swars::BattleHistoryScript, nil]
# >> [QuickScript::Swars::DocumentationScript, nil]
# >> [QuickScript::Swars::UserGroupScript, nil]
# >> [QuickScript::Swars::ProScript, nil]
# >> [QuickScript::Swars::PrisonAllScript, nil]
# >> [QuickScript::Swars::PrisonSearchScript, nil]
# >> [QuickScript::Swars::PrisonNewScript, nil]
# >> [QuickScript::Swars::PiyoShogiConfigScript, nil]
# >> [QuickScript::Tool::ShortUrlScript, nil]
# >> |---------------------------------------------------|
# >> | QuickScript::About::CreditScript                  |
# >> | QuickScript::About::PrivacyPolicyScript           |
# >> | QuickScript::About::TermsScript                   |
# >> | QuickScript::Account::DestroyScript               |
# >> | QuickScript::Account::EmailEditScript             |
# >> | QuickScript::Account::InfoScript                  |
# >> | QuickScript::Account::KentoProDestroyScript       |
# >> | QuickScript::Account::LogoutScript                |
# >> | QuickScript::Account::NameEditScript              |
# >> | QuickScript::Account::ProfileImageUploadScript    |
# >> | QuickScript::Account::SnsAccountIntegrationScript |
# >> | QuickScript::Admin::LoginScript                   |
# >> | QuickScript::Admin::SwarsAgentScript              |
# >> | QuickScript::Chore::DocumentationScript           |
# >> | QuickScript::Chore::GroupScript                   |
# >> | QuickScript::Chore::IndexScript                   |
# >> | QuickScript::Chore::InvisibleScript               |
# >> | QuickScript::Chore::MarkdownScript                |
# >> | QuickScript::Chore::MessageScript                 |
# >> | QuickScript::Chore::NotFoundScript                |
# >> | QuickScript::Chore::NullScript                    |
# >> | QuickScript::Chore::StatusCodeScript              |
# >> | QuickScript::Dev::BackgroundJobScript             |
# >> | QuickScript::Dev::CalcScript                      |
# >> | QuickScript::Dev::CsvDownloadGetScript            |
# >> | QuickScript::Dev::CsvDownloadPostScript           |
# >> | QuickScript::Dev::DelegateScript                  |
# >> | QuickScript::Dev::EmojiScript                     |
# >> | QuickScript::Dev::ErrorScript                     |
# >> | QuickScript::Dev::Fake500Script                   |
# >> | QuickScript::Dev::FetchIndexScript                |
# >> | QuickScript::Dev::FlashScript                     |
# >> | QuickScript::Dev::FooBarBazScript                 |
# >> | QuickScript::Dev::FormScript                      |
# >> | QuickScript::Dev::HelloScript                     |
# >> | QuickScript::Dev::HtmlScript                      |
# >> | QuickScript::Dev::InvalidateBasicAuthScript       |
# >> | QuickScript::Dev::InvisibleScript                 |
# >> | QuickScript::Dev::LoginRequired1Script            |
# >> | QuickScript::Dev::LoginRequired2Script            |
# >> | QuickScript::Dev::MarkdownScript                  |
# >> | QuickScript::Dev::NavibarFalseScript              |
# >> | QuickScript::Dev::NullScript                      |
# >> | QuickScript::Dev::PageReloadScript                |
# >> | QuickScript::Dev::PiyoShogiConfigComponentScript  |
# >> | QuickScript::Dev::Post1Script                     |
# >> | QuickScript::Dev::Post2FormCounterScript          |
# >> | QuickScript::Dev::Post3SessionCounterScript       |
# >> | QuickScript::Dev::PostAndRedirectScript           |
# >> | QuickScript::Dev::Redirect1Script                 |
# >> | QuickScript::Dev::Redirect2Script                 |
# >> | QuickScript::Dev::Redirect3Script                 |
# >> | QuickScript::Dev::SessionCounterScript            |
# >> | QuickScript::Dev::SessionScript                   |
# >> | QuickScript::Dev::SheetScript                     |
# >> | QuickScript::Dev::SidebarScript                   |
# >> | QuickScript::Dev::SleepScript                     |
# >> | QuickScript::Dev::StatusCodeTesterScript          |
# >> | QuickScript::Dev::TableScript                     |
# >> | QuickScript::Dev::UrlHelpersScript                |
# >> | QuickScript::Dev::ValueScript                     |
# >> | QuickScript::Dev::ZipDownloadPostScript           |
# >> | QuickScript::Group1::HelloScript                  |
# >> | QuickScript::Swars::BattleHistoryScript           |
# >> | QuickScript::Swars::DocumentationScript           |
# >> | QuickScript::Swars::UserGroupScript               |
# >> | QuickScript::Swars::ProScript                     |
# >> | QuickScript::Swars::PrisonAllScript               |
# >> | QuickScript::Swars::PrisonSearchScript            |
# >> | QuickScript::Swars::PrisonNewScript               |
# >> | QuickScript::Swars::PiyoShogiConfigScript         |
# >> | QuickScript::Tool::ShortUrlScript                 |
# >> |---------------------------------------------------|
# >> |---------------------------------------------------|
# >> | QuickScript::About::CreditScript                  |
# >> | QuickScript::About::PrivacyPolicyScript           |
# >> | QuickScript::About::TermsScript                   |
# >> | QuickScript::Account::DestroyScript               |
# >> | QuickScript::Account::EmailEditScript             |
# >> | QuickScript::Account::InfoScript                  |
# >> | QuickScript::Account::KentoProDestroyScript       |
# >> | QuickScript::Account::LogoutScript                |
# >> | QuickScript::Account::NameEditScript              |
# >> | QuickScript::Account::ProfileImageUploadScript    |
# >> | QuickScript::Account::SnsAccountIntegrationScript |
# >> | QuickScript::Admin::LoginScript                   |
# >> | QuickScript::Admin::SwarsAgentScript              |
# >> | QuickScript::Chore::DocumentationScript           |
# >> | QuickScript::Chore::GroupScript                   |
# >> | QuickScript::Chore::IndexScript                   |
# >> | QuickScript::Chore::InvisibleScript               |
# >> | QuickScript::Chore::MarkdownScript                |
# >> | QuickScript::Chore::MessageScript                 |
# >> | QuickScript::Chore::NotFoundScript                |
# >> | QuickScript::Chore::NullScript                    |
# >> | QuickScript::Chore::StatusCodeScript              |
# >> | QuickScript::Dev::BackgroundJobScript             |
# >> | QuickScript::Dev::CalcScript                      |
# >> | QuickScript::Dev::CsvDownloadGetScript            |
# >> | QuickScript::Dev::CsvDownloadPostScript           |
# >> | QuickScript::Dev::DelegateScript                  |
# >> | QuickScript::Dev::EmojiScript                     |
# >> | QuickScript::Dev::ErrorScript                     |
# >> | QuickScript::Dev::Fake500Script                   |
# >> | QuickScript::Dev::FetchIndexScript                |
# >> | QuickScript::Dev::FlashScript                     |
# >> | QuickScript::Dev::FooBarBazScript                 |
# >> | QuickScript::Dev::FormScript                      |
# >> | QuickScript::Dev::HelloScript                     |
# >> | QuickScript::Dev::HtmlScript                      |
# >> | QuickScript::Dev::InvalidateBasicAuthScript       |
# >> | QuickScript::Dev::InvisibleScript                 |
# >> | QuickScript::Dev::LoginRequired1Script            |
# >> | QuickScript::Dev::LoginRequired2Script            |
# >> | QuickScript::Dev::MarkdownScript                  |
# >> | QuickScript::Dev::NavibarFalseScript              |
# >> | QuickScript::Dev::NullScript                      |
# >> | QuickScript::Dev::PageReloadScript                |
# >> | QuickScript::Dev::PiyoShogiConfigComponentScript  |
# >> | QuickScript::Dev::Post1Script                     |
# >> | QuickScript::Dev::Post2FormCounterScript          |
# >> | QuickScript::Dev::Post3SessionCounterScript       |
# >> | QuickScript::Dev::PostAndRedirectScript           |
# >> | QuickScript::Dev::Redirect1Script                 |
# >> | QuickScript::Dev::Redirect2Script                 |
# >> | QuickScript::Dev::Redirect3Script                 |
# >> | QuickScript::Dev::SessionCounterScript            |
# >> | QuickScript::Dev::SessionScript                   |
# >> | QuickScript::Dev::SheetScript                     |
# >> | QuickScript::Dev::SidebarScript                   |
# >> | QuickScript::Dev::SleepScript                     |
# >> | QuickScript::Dev::StatusCodeTesterScript          |
# >> | QuickScript::Dev::TableScript                     |
# >> | QuickScript::Dev::UrlHelpersScript                |
# >> | QuickScript::Dev::ValueScript                     |
# >> | QuickScript::Dev::ZipDownloadPostScript           |
# >> | QuickScript::Group1::HelloScript                  |
# >> | QuickScript::Swars::BattleHistoryScript           |
# >> | QuickScript::Swars::DocumentationScript           |
# >> | QuickScript::Swars::UserGroupScript               |
# >> | QuickScript::Swars::ProScript                     |
# >> | QuickScript::Swars::PrisonAllScript               |
# >> | QuickScript::Swars::PrisonSearchScript            |
# >> | QuickScript::Swars::PrisonNewScript               |
# >> | QuickScript::Swars::PiyoShogiConfigScript         |
# >> | QuickScript::Tool::ShortUrlScript                 |
# >> |---------------------------------------------------|
