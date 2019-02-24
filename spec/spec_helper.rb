$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')
$LOAD_PATH << File.join(File.dirname(__FILE__))

if ENV['RUN_COVERAGE_REPORT']
  require 'simplecov'

  SimpleCov.start do
    add_filter 'vendor/'
    add_filter %r{^/spec/}
  end

  SimpleCov.minimum_coverage_by_file 90
end

require 'functional-light-service'
require 'functional-light-service/testing'
require "functional-light-service/functional/null"
require 'ostruct'
require 'pry'
require 'support'
require 'test_doubles'
require 'stringio'

I18n.enforce_available_locales = true
