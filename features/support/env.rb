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

Before do
    $init_setup_actions ||= false # have to define a variable before we can reference its value
    if !$init_setup_actions
        #clearing the junk files from results folder
        # Dir.glob("#{Dir.pwd}/reports/html/*").select{ |file| /html_result.html/.match file }.each { |file| File.delete(file)}
        # Dir.glob("#{Dir.pwd}/reports/pretty/*").select{ |file| /pretty.txt/.match file }.each { |file| File.delete(file)}
        # Dir.glob("#{Dir.pwd}/reports/progress/*").select{ |file| /progress.txt/.match file }.each { |file| File.delete(file)}
        # Dir.glob("#{Dir.pwd}/reports/cucumber_rerun/*").select{ |file| /rerun.txt/.match file }.each { |file| File.delete(file)}
        Dir.glob("#{Dir.pwd}/reports/runtime_files/*").select{ |file| /.json/.match file }.each { |file| File.delete(file)}
        Dir.glob("#{Dir.pwd}/reports/runtime_files/*").select{ |file| /.graphql/.match file }.each { |file| File.delete(file)}
        @@global_response_data = {}
        @@runtime_variables = {}
        @@tentative_count = 0
    end
    $init_setup_actions = true
end

Before('@TC_SA_Features') do
    $before_TC_SA_Features ||= false # have to define a variable before we can reference its value
    if !$before_TC_SA_Features
        # graphql_initialize = GqlHelper.new(ENV["URL"])
        @http_adaptor = GraphQL::Client::HTTP.new("https://corev2-dev-rs.weinvest-stage.net/graphql") do
            def headers(context)
                {
                    "WEINVEST_SERVICE_TOKEN": "e9695057ea59c7173704ff1ec4f2a08e5e10f20db2246bbf62f48990f6570865"
                }
            end
        end
        @http_schema = GraphQL::Client.load_schema(@http_adaptor)
        @@http_client = GraphQL::Client.new(schema: @http_schema, execute: @http_adaptor)
        @@http_client.allow_dynamic_queries = true
        $client = @@http_client
    end
    $before_TC_SA_Features = true
end

$http = nil
$VERBOSE = nil


Before do |scenario|
    (@@http_client == nil).should eql(false), "Graphql client is nil check the server"
end
  
After do |scenario|
    if scenario.outline?
        attach_file("#{scenario.feature.name.gsub(" ","_").gsub(",","_").gsub('"','')}_#{scenario.scenario_outline.name.gsub(" ","_").gsub(",","_").gsub('"','')}_response.json".to_s,ReportsHelper.save_response_file(scenario))
        attach_file("#{scenario.feature.name.gsub(" ","_").gsub(",","_").gsub('"','')}_#{scenario.scenario_outline.name.gsub(" ","_").gsub(",","_").gsub('"','')}_expected.json".to_s,ReportsHelper.save_expected_json(scenario))
        attach_file("#{scenario.feature.name.gsub(" ","_").gsub(",","_").gsub('"','')}_#{scenario.scenario_outline.name.gsub(" ","_").gsub(",","_").gsub('"','')}_error.json".to_s,ReportsHelper.save_error_file(scenario))
        attach_file("#{scenario.feature.name.gsub(" ","_").gsub(",","_").gsub('"','')}_#{scenario.scenario_outline.name.gsub(" ","_").gsub(",","_").gsub('"','')}_query.graphql".to_s,ReportsHelper.save_query_file(scenario))
        attach_file("#{scenario.feature.name.gsub(" ","_").gsub(",","_").gsub('"','')}_#{scenario.scenario_outline.name.gsub(" ","_").gsub(",","_").gsub('"','')}_query_variable.json".to_s,ReportsHelper.save_variable_file(scenario))
        ReportsHelper.copy_response_to_expected_file(scenario) if ENV['snap'] == "1" && scenario.failed?
        @@tentative_count = @@tentative_count + 1
    else
        attach_file("#{scenario.feature.name.gsub(" ","_").gsub(",","_")}_#{scenario.name.gsub(" ","_").gsub(",","_").gsub('"','')}_response.json".to_s,ReportsHelper.save_response_file(scenario))
        attach_file("#{scenario.feature.name.gsub(" ","_").gsub(",","_")}_#{scenario.name.gsub(" ","_").gsub(",","_").gsub('"','')}_expected.json".to_s,ReportsHelper.save_expected_json(scenario))
        attach_file("#{scenario.feature.name.gsub(" ","_").gsub(",","_")}_#{scenario.name.gsub(" ","_").gsub(",","_").gsub('"','')}_error.json".to_s,ReportsHelper.save_error_file(scenario))
        attach_file("#{scenario.feature.name.gsub(" ","_").gsub(",","_")}_#{scenario.name.gsub(" ","_").gsub(",","_").gsub('"','')}_query.graphql".to_s,ReportsHelper.save_query_file(scenario))
        attach_file("#{scenario.feature.name.gsub(" ","_").gsub(",","_")}_#{scenario.name.gsub(" ","_").gsub(",","_").gsub('"','')}_query_variable.json".to_s,ReportsHelper.save_variable_file(scenario))
        ReportsHelper.copy_response_to_expected_file(scenario) if ENV['snap'] == "1" && scenario.failed?
    end
    @@runtime_variables = {} if @@tentative_count > 99
end