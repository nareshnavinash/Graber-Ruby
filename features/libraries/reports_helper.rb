require 'json'

module Graber
    class ReportsHelper

        def self.save_query_file(scenario_object)
            if scenario_object.outline?
                new_json_file_path = File.join(File.join("#{Pathname.pwd}","reports","runtime_files"),"#{scenario_object.feature.name.gsub(" ","_").gsub(",","_").gsub('"','')}_#{scenario_object.scenario_outline.name.gsub(" ","_").gsub(",","_").gsub('"','')}_query.graphql")
            else
                new_json_file_path = File.join(File.join("#{Pathname.pwd}","reports","runtime_files"),"#{scenario_object.feature.name.gsub(" ","_").gsub(",","_").gsub('"','')}_#{scenario_object.name.gsub(" ","_").gsub(",","_").gsub('"','')}_query.graphql")
            end
            file = File.open(new_json_file_path, "w")
            file.puts @@query
            file.close
            # puts  "file attached with the test case--->"+"#{new_json_file_path}"
            return File.open(new_json_file_path)
        end

        def self.save_variable_file(scenario_object)
            if scenario_object.outline?
                new_json_file_path = File.join(File.join("#{Pathname.pwd}","reports","runtime_files"),"#{scenario_object.feature.name.gsub(" ","_").gsub(",","_").gsub('"','')}_#{scenario_object.scenario_outline.name.gsub(" ","_").gsub(",","_").gsub('"','')}_variable.json")
            else
                new_json_file_path = File.join(File.join("#{Pathname.pwd}","reports","runtime_files"),"#{scenario_object.feature.name.gsub(" ","_").gsub(",","_").gsub('"','')}_#{scenario_object.name.gsub(" ","_").gsub(",","_").gsub('"','')}_variable.json")
            end
            file = File.open(new_json_file_path, "w")
            file.puts JSON.pretty_generate(@@variables)
            file.close
            # puts  "file attached with the test case--->"+"#{new_json_file_path}"
            return File.open(new_json_file_path)
        end

        def self.save_response_file(scenario_object)
            if scenario_object.outline?
                new_json_file_path = File.join(File.join("#{Pathname.pwd}","reports","runtime_files"),"#{scenario_object.feature.name.gsub(" ","_").gsub(",","_").gsub('"','')}_#{scenario_object.scenario_outline.name.gsub(" ","_").gsub(",","_").gsub('"','')}_response.json")
            else
                new_json_file_path = File.join(File.join("#{Pathname.pwd}","reports","runtime_files"),"#{scenario_object.feature.name.gsub(" ","_").gsub(",","_").gsub('"','')}_#{scenario_object.name.gsub(" ","_").gsub(",","_").gsub('"','')}_response.json")
            end
            file = File.open(new_json_file_path, "w")
            file.puts JSON.pretty_generate(@@response_json['data'])
            file.close
            # puts  "file attached with the test case--->"+"#{new_json_file_path}"
            return File.open(new_json_file_path)
        end

        def self.save_error_file(scenario_object)
            if scenario_object.outline?
                new_json_file_path = File.join(File.join("#{Pathname.pwd}","reports","runtime_files"),"#{scenario_object.feature.name.gsub(" ","_").gsub(",","_").gsub('"','')}_#{scenario_object.scenario_outline.name.gsub(" ","_").gsub(",","_").gsub('"','')}_error.json")
            else
                new_json_file_path = File.join(File.join("#{Pathname.pwd}","reports","runtime_files"),"#{scenario_object.feature.name.gsub(" ","_").gsub(",","_").gsub('"','')}_#{scenario_object.name.gsub(" ","_").gsub(",","_").gsub('"','')}_error.json")
            end
            file = File.open(new_json_file_path, "w")
            file.puts JSON.pretty_generate(@@response_errors)
            file.close
            # puts  "file attached with the test case--->"+"#{new_json_file_path}"
            return File.open(new_json_file_path)
        end

        def self.save_expected_json(scenario_object)
            if scenario_object.outline?
                new_json_file_path = File.join(File.join("#{Pathname.pwd}","reports","runtime_files"),"#{scenario_object.feature.name.gsub(" ","_").gsub(",","_").gsub('"','')}_#{scenario_object.scenario_outline.name.gsub(" ","_").gsub(",","_").gsub('"','')}_expected.json")
            else
                new_json_file_path = File.join(File.join("#{Pathname.pwd}","reports","runtime_files"),"#{scenario_object.feature.name.gsub(" ","_").gsub(",","_").gsub('"','')}_#{scenario_object.name.gsub(" ","_").gsub(",","_").gsub('"','')}_expected.json")
            end
            file = File.open(new_json_file_path, "w")
            file.puts JSON.pretty_generate(@@expected_json)
            file.close
            # puts  "file attached with the test case--->"+"#{new_json_file_path}"
            return File.open(new_json_file_path)
        end

        def self.copy_response_to_expected_file(scenario_object)
            new_json_file_path = File.join(File.join("#{Pathname.pwd}","reports","runtime_files"),"#{scenario_object.feature.name.gsub(" ","_").gsub(",","_").gsub('"','')}_#{scenario_object.name.gsub(" ","_").gsub(",","_").gsub('"','')}_response.json")
            expected_json_path = @@expected_json_filepath
            if expected_json_path != nil
                IO.copy_stream(new_json_file_path, expected_json_path)
                puts "*- Copied response to the stored dump for #{stored_json_path}"
            end
        end

    end
end
