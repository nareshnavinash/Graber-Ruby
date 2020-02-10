require 'parseconfig'

module Graber
    @@conf_values = {}
    @@support_file_path = File.join("#{Pathname.pwd}","graphql")
    @@gql_filepath = ""
    @@graphql_query = ""
    @@query_variable_filepath = ""
    @@expected_json_filepath = ""
    @@expected_json = ""
    @@exclude_keys = []

    class File

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
                return result.to_h
            rescue Exception => e
                puts "Json file read is failed \n filename: #{json_file_name} \n #{e.message}"
            end
        end

        def self.update_json_values_from_config(json_content)
            begin
                result = json_content
                value_as_array =  json_content.scan(/_\$(\w+)\$_/)
                value_as_array.each do |value|
                    value.each do |child|
                        conf_values_length = @@conf_values[child].split(",").length
                        if child.include? ("_int")
                            if conf_values_length == 1
                                result = result.gsub("$"+child, @@conf_values[child].chomp('"').delete_prefix('"'))
                            else
                                result = result.gsub("$"+child, @@conf_values[child].split(",").map { |i|  i.to_s  }.join(",").chomp('"').delete_prefix('"'))
                            end
                        elsif child.include? ("empty_array")
                            result = result.gsub("$"+child, "".chomp('"').delete_prefix('"'))
                        else
                            if conf_values_length == 1
                                result = result.gsub("$"+child, @@conf_values[child])
                            else
                                result = result.gsub("$"+child, @@conf_values[child].split(",").map { |i|  i.to_s  }.join(","))
                            end
                        end
                    end
                end
                return result.gsub("nil","null")
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
                @@expected_json = File.read(@@expected_json_filepath)
                return @@expected_json.to_h
            rescue Exception => e
                puts "Json file read is failed \n filename: #{json_file_name} \n #{e.message}"
            end
        end

    end
end