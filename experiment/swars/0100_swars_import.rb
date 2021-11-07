#!/usr/bin/env ruby
require File.expand_path('../../../config/environment', __FILE__)
Swars::Battle.destroy_all
Swars::Battle.user_import(user_key: "itoshinTV")
