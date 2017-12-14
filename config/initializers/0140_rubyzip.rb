Zip.setup do |c|
  c.unicode_names = true
  # c.on_exists_proc = false
  # c.continue_on_exists_proc = false
  c.sort_entries = true
  # c.default_compression = ::Zlib::DEFAULT_COMPRESSION
  # c.write_zip64_support = false
  c.warn_invalid_date = true
  # c.case_insensitive_match = false
end
