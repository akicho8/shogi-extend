#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

FreeBattle.destroy_all
ActiveStorage::Attachment.destroy_all
ActiveStorage::Blob.destroy_all
`rm -fr #{Rails.root}/storage/*`

r = FreeBattle.create!
r.image_auto_cerate_onece
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
# >> └── Bi
# >>     └── iD
# >>         └── BiiDAJK61GHQwCvc2LHgZUm7
# >> 
# >> 2 directories, 1 file
# >> |----+-----------------+-------------+-----------+---------+---------------------------|
# >> | id | name            | record_type | record_id | blob_id | created_at                |
# >> |----+-----------------+-------------+-----------+---------+---------------------------|
# >> | 19 | thumbnail_image | FreeBattle  |       147 |      19 | 2020-01-31 22:15:39 +0900 |
# >> |----+-----------------+-------------+-----------+---------+---------------------------|
# >> |----+--------------------------+--------------------------------------+--------------+----------------------+-----------+--------------------------+---------------------------|
# >> | id | key                      | filename                             | content_type | metadata             | byte_size | checksum                 | created_at                |
# >> |----+--------------------------+--------------------------------------+--------------+----------------------+-----------+--------------------------+---------------------------|
# >> | 19 | BiiDAJK61GHQwCvc2LHgZUm7 | 9cec557aa3cec8fea4dcfcf0fc0d7472.png | image/png    | {"identified"=>true} |     29671 | DQutetmTo9yLWGoJJi+z8w== | 2020-01-31 22:15:39 +0900 |
# >> |----+--------------------------+--------------------------------------+--------------+----------------------+-----------+--------------------------+---------------------------|
# >> |--------|
# >> | 削除後 |
# >> |--------|
# >> |----+--------------------------+--------------------------------------+--------------+----------------------------------------------------------------------+-----------+--------------------------+---------------------------|
# >> | id | key                      | filename                             | content_type | metadata                                                             | byte_size | checksum                 | created_at                |
# >> |----+--------------------------+--------------------------------------+--------------+----------------------------------------------------------------------+-----------+--------------------------+---------------------------|
# >> | 19 | BiiDAJK61GHQwCvc2LHgZUm7 | 9cec557aa3cec8fea4dcfcf0fc0d7472.png | image/png    | {"identified"=>true, "width"=>1200, "height"=>630, "analyzed"=>true} |     29671 | DQutetmTo9yLWGoJJi+z8w== | 2020-01-31 22:15:39 +0900 |
# >> |----+--------------------------+--------------------------------------+--------------+----------------------------------------------------------------------+-----------+--------------------------+---------------------------|
# >> ../storage
# >> └── Bi
# >>     └── iD
# >>         └── BiiDAJK61GHQwCvc2LHgZUm7
# >> 
# >> 2 directories, 1 file
