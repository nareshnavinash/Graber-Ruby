require 'json'

module Graber
    class ReportsHelper

        def self.save_all_variables_as_files(scenario_object)
            query = @@query
            variable = JSON.pretty_generate(@@variables)
            response_json = JSON.pretty_generate(@@response_json)
            error_json = JSON.pretty_generate(@@response_errors)
            expected_json = JSON.pretty_generate(@@expected_json)


            if scenario_object.outline?
                new_json_file_path = File.join(File.join("#{Pathname.pwd}","ResponseJSON"),"#{scenario_object.feature.name.gsub(" ","_").gsub(",","_").gsub('"','')}_#{scenario_object.scenario_outline.name.gsub(" ","_").gsub(",","_").gsub('"','')}_query.graphql")
            else
                new_json_file_path = File.join(File.join("#{Pathname.pwd}","ResponseJSON"),"#{scenario_object.feature.name.gsub(" ","_").gsub(",","_").gsub('"','')}_#{scenario_object.name.gsub(" ","_").gsub(",","_").gsub('"','')}_query.graphql")
            end
            file = File.open(new_json_file_path, "w")
            file.puts @@query
            file.close
            # puts  "file attached with the test case--->"+"#{new_json_file_path}"
            return File.open(new_json_file_path)
        end
    end
end