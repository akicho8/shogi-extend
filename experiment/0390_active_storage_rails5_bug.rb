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

tp ActiveStorage::Attachment
tp ActiveStorage::Blob

# ↓これを呼べば消えるが destroy では消えない。has_one_attached :xxx, dependent: :purge にしているにもかかわらず！
# r.thumbnail_image.purge
r.destroy

tp "削除後"
tp ActiveStorage::Attachment
tp ActiveStorage::Blob
puts `tree ../storage`

# >> ../storage
# >> └── Mt
# >>     └── FQ
# >>         └── MtFQpAPLABWKtDyRDqchCScj
# >> 
# >> 2 directories, 1 file
# >> |----+-----------------+-------------+-----------+---------+---------------------------|
# >> | id | name            | record_type | record_id | blob_id | created_at                |
# >> |----+-----------------+-------------+-----------+---------+---------------------------|
# >> | 18 | thumbnail_image | FreeBattle  |        25 |      18 | 2020-02-04 15:10:37 +0900 |
# >> |----+-----------------+-------------+-----------+---------+---------------------------|
# >> |----+--------------------------+--------------------------------------+--------------+----------------------+-----------+--------------------------+---------------------------|
# >> | id | key                      | filename                             | content_type | metadata             | byte_size | checksum                 | created_at                |
# >> |----+--------------------------+--------------------------------------+--------------+----------------------+-----------+--------------------------+---------------------------|
# >> | 18 | MtFQpAPLABWKtDyRDqchCScj | 52e81ed6a34afc45b71437fc7f7482c1.png | image/png    | {"identified"=>true} |     29668 | TpPtFxYfYqPNprEQBqulXg== | 2020-02-04 15:10:37 +0900 |
# >> |----+--------------------------+--------------------------------------+--------------+----------------------+-----------+--------------------------+---------------------------|
# >> |--------|
# >> | 削除後 |
# >> |--------|
# >> ../storage
# >> └── Mt
# >>     └── FQ
# >> 
# >> 2 directories, 0 files
