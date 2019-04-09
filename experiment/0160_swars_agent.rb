#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

tp Swars::Agent.new(run_remote: true).index_get(gtype: "",  user_key: "kinakom0chi2", page_index: 0)
