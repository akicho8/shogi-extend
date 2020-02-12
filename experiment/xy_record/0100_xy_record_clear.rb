#!/usr/bin/env ruby
require File.expand_path('../../../config/environment', __FILE__)

XyRecord.destroy_all
XyRuleInfo.redis.flushdb
