#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

FreeBattle.destroy_all
ActiveStorage::Attachment.destroy_all
ActiveStorage::Blob.destroy_all
`rm -fr #{Rails.root}/storage/*`

r = FreeBattle.create!
r.image_auto_cerate_onece({})
r.thumbnail_image.attached?     # => true
puts `tree ../storage`
# >> ../storage
# >> └── MM
# >>     └── fg
# >>         └── MMfgZZVzajMy6JugouhoJmhG
# >> 
# >> 2 directories, 1 file
