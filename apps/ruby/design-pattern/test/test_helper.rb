# frozen_string_literal: true

require 'simplecov'
SimpleCov.start do
  add_filter '/test/'
  enable_coverage :branch
  minimum_coverage 80
end

require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new]
