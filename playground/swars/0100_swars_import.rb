#!/usr/bin/env ruby
require File.expand_path('../../../config/environment', __FILE__)
Swars::Battle.destroy_all
Swars::Importer::UserImporter.new(user_key: "itoshinTV").run
