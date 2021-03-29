# frozen_string_literal: true

VRT.configure do |config|
  # Example to return an array from `get_lineage`
  # config.lineage_string_separator = nil
end

# Pre-warm the in-memory store of these class instance vars when we launch the
# server. Prevents unnecessary file I/O per-request.
VRT.reload!
