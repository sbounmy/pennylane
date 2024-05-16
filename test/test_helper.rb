# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "pennylane"

require "test-unit"
require "minitest"
# Minitest::Reporters.use! unless ENV['RM_INFO']
require "vcr"
require "webmock/minitest"
require "modules/with_vcr"
require "timecop"

VCR.configure do |c|
  c.cassette_library_dir = "test/fixtures/vcr_cassettes"
  c.hook_into :webmock
  c.default_cassette_options = { record: :once, match_requests_on: %i[method uri body] }
end

require "active_support/testing/assertions"

include ActiveSupport::Testing::Assertions
include WithVCR