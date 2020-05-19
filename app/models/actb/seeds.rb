Actb::AnsResult.setup(options)
Actb::Season.setup(options)
Actb::Lineage.setup(options)

Colosseum::User.find_each(&:create_various_folders_if_blank)
# Colosseum::User.find_each(&:actb_newest_profile)
