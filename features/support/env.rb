require 'cucumber'
require 'allure-cucumber'
require 'require_all'
require 'fileutils'
require 'pathname'
require 'json'
require 'pry'
require 'date'
require 'httpclient'
require_rel "../libraries/"

include AllureCucumber::DSL
include Graber

AllureCucumber.configure do |c|
  c.output_dir = "reports/allure"
  c.clean_dir  = true
end

Cucumber::Core::Test::Step.module_eval do
  def name
    return text if self.text == 'Before hook'
    return text if self.text == 'After hook'
    "#{source.last.keyword}#{text}"
  end
end

$http = nil
$VERBOSE = nil
