Actb::OxMark.setup(options)
Actb::Season.setup(options)
Actb::Lineage.setup(options)
Actb::Judge.setup(options)
Actb::Rule.setup(options)
Actb::Final.setup(options)

User.find_each(&:create_various_folders_if_blank)
User.find_each(&:create_actb_setting_if_blank)
User.find_each(&:create_actb_season_xrecord_if_blank)
User.find_each(&:create_actb_master_xrecord_if_blank)

