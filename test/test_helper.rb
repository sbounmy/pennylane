# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "pennylane"

require "test-unit"
require 'minitest'
# Minitest::Reporters.use! unless ENV['RM_INFO']
require 'vcr'

require 'active_support/testing/assertions'

include ActiveSupport::Testing::Assertions