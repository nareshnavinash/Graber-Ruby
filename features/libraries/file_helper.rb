require 'parseconfig'
require 'pathname'

module Graber
    @@support_file_path = File.join("#{Pathname.pwd}","graphql")
    @@gql_filepath = ""
    @@graphql_query = ""
    @@query_variable_filepath = ""
    @@expected_json_filepath = ""
    @@expected_json = {}
    @@exclude_keys = []

    class FileHelper

        def self.read_graphql_file(graphql_file_name)
            begin
                Dir["#{@@support_file_path}/query/**/*.graphql"].each do |file|
                    if file.split('/').last == graphql_file_name
                        @@gql_filepath = file
                        break
                    end
                end
                @@graphql_query = File.read(@@gql_filepath)
                return @@graphql_query
            rescue Exception => e
                puts "Graphql file read failed \n#{} \n #{e.message}"
            end
        end
        
        def self.read_query_variable_json_file(json_file_name)
            begin
                Dir["#{@@support_file_path}/variable/**/*.json"].each do |file|
                    if file.split('/').last == json_file_name
                        @@query_variable_filepath = file
                        break
                    end
                end
                json_content = File.read(@@query_variable_filepath)
                result = update_json_values_from_config(json_content)
                return result
            rescue Exception => e
                puts "Json file read is failed \n filename: #{json_file_name} \n #{e.message}"
            end
        end

        def self.update_json_values_from_config(json_content)
            begin
                result = json_content
                value_as_array =  JSON.parse(json_content).to_h
                value_as_array.map do |key, value|
                    if value.to_s.include? "$"
                        trimed_value = value.to_s.gsub("$", "")
                        @@runtime_variables.map{ |k,v| val = trimed_value.to_s.include? k; @runtime_key = k if val == true }
                        if @@runtime_variables[@runtime_key] != nil
                            conf_values_length = @@runtime_variables[@runtime_key].split(",").length
                            if @runtime_key.include? ("_int")
                                if conf_values_length == 1
                                    result = result.gsub("$"+@runtime_key, @@runtime_variables[@runtime_key].chomp('"').delete_prefix('"'))
                                else
                                    result = result.gsub("$"+@runtime_key, @@runtime_variables[@runtime_key].split(",").map { |i|  i.to_s  }.join(",").chomp('"').delete_prefix('"'))
                                end
                            else
                                if conf_values_length == 1
                                    if @@runtime_variables[@runtime_key] == "empty"
                                        result = result.gsub("\"$"+@runtime_key+"\"", "".chomp('"').delete_prefix('"'))
                                    else
                                        result = result.gsub("$"+@runtime_key, @@runtime_variables[@runtime_key])
                                    end
                                else
                                    result = result.gsub("$"+@runtime_key, @@runtime_variables[@runtime_key].split(",").map { |i|  i.to_s  }.join(","))
                                end
                            end
                        end
                    end
                end
                return JSON.parse(result.gsub("nil","null"))
            rescue Exception => e
                puts "Exception occured while saving user input values to the json \n #{e.message}"
            end
        end

        def self.read_expected_json_file(json_file_name)
            begin
                Dir["#{@@support_file_path}/expected_jsons/**/*.json"].each do |file|
                    if file.split('/').last == json_file_name
                        @@expected_json_filepath = file
                        break
                    end
                end
                @@expected_json = JSON.parse(File.read(@@expected_json_filepath))
                return @@expected_json
            rescue Exception => e
                puts "Json file read is failed \n filename: #{json_file_name} \n #{e.message}"
            end
        end

    end
end