Actb::OxMark.setup(options)
Actb::Season.setup(options)
Actb::Lineage.setup(options)
Actb::Judge.setup(options)
Actb::Rule.setup(options)
Actb::Final.setup(options)

Colosseum::User.find_each(&:create_various_folders_if_blank)
Colosseum::User.find_each(&:create_actb_setting_if_blank)
Colosseum::User.find_each(&:create_actb_xrecord_if_blank)

