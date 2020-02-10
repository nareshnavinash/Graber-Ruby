require 'parseconfig'

module Grabber
    @@conf_values = {}
    @@support_file_path = File.join("#{Pathname.pwd}","Graphql")
    @@gql_filepath = ""
    @@graphql_query = ""
    @@json_filepath = ""
    @@stored_filepath = ""

    class File

        def self.read_conf_files
            Dir["#{@@support_file_path}/**/*.conf"].each do |file|
                @@conf_values.merge!(ParseConfig.new(file).params.to_h)
            end
            return @@conf_values
        end

        def self.read_graphql_file(graphql_file_name)
            begin
                Dir["#{@@support_file_path}/**/*.graphql"].each do |file|
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
        
        def self.read_json_file(json_file_name, response=nil)
            file_path = ""
            begin
                Dir["#{@@support_file_path}/**/*.json"].each do |file|
                    if file.split('/').last == json_file_name
                        file_path = file
                        break
                    end
                end
                if response == "stored"
                    @@stored_filepath = file_path
                else
                    @@json_filepath = file_path
                end
                json_content = File.read(file_path)
                result = update_json_values(json_content)
                return result.to_h
            rescue Exception => e
                puts "Json file read is failed \n filename: #{json_file_name} \n #{e.message}"
            end
        end

        def self.update_json_values(json_content)
            begin
                result = json_content
                value_as_array =  json_content.scan(/_\$(\w+)\$_/)
                value_as_array.each do |value|
                    value.each do |child|
                        conf_values_length = @@conf_values[child].split(",").length
                        if child.include? ("_int")
                            if conf_values_length == 1
                                result = result.gsub(child, @@conf_values[child].chomp('"').delete_prefix('"'))
                            else
                                result = result.gsub(child, @@conf_values[child].split(",").map { |i|  i.to_s  }.join(",").chomp('"').delete_prefix('"'))
                            end
                        elsif child.include? ("empty_array")
                            result = result.gsub(child, "".chomp('"').delete_prefix('"'))
                        elsif child.include? ("_timestamp")
                            result = result.gsub(child, "#{@@conf_values[child].delete_suffix!('_timestamp')}"+"#{Time.now.utc.to_s.gsub(' ','').gsub(':','').gsub('-','')}")
                        else
                            if conf_values_length == 1
                                result = result.gsub(child, @@conf_values[child])
                            else
                                result = result.gsub(child, @@conf_values[child].split(",").map { |i|  i.to_s  }.join(","))
                            end
                        end
                    end
                end
                return result.gsub("nil","null")
            rescue Exception => e
                puts "Exception occured while saving user input values to the json \n #{e.message}"
            end
        end

    end
end