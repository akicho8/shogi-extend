#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

auth_info = AuthInfo.last
tp auth_info
tp auth_info.meta_info
