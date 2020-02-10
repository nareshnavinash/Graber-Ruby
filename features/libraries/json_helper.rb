require 'json-diff'
require 'json'
require 'json-compare'
require 'hashdiff'

module Graber
    class JsonHelper
        
        def self.bool_data_compare
            return JsonCompare.get_diff(@@response_json.data.to_h, @@expected_json.to_h, @@exclude_keys).empty?
        end

        def self.bool_error_compare
            return JsonCompare.get_diff(@@response_json.error.to_h, @@expected_json.to_h, @@exclude_keys).empty?
        end

        def self.string_data_compare
            diff = JsonDiff.diff(@@expected_json,JSON.parse(@@response_json.data.to_h.to_json),{:include_was => true,:moves => false })
            pretty_json = JSON.pretty_generate(diff)
            return pretty_json.gsub("\"was\"","\"actual\"").gsub("\"value\"","\"expected\"",).gsub("/",".")
        end

        def self.string_error_compare
            diff = JsonDiff.diff(@@expected_json,JSON.parse(@@response_json.error.to_h.to_json),{:include_was => true,:moves => false })
            pretty_json = JSON.pretty_generate(diff)
            return pretty_json.gsub("\"was\"","\"actual\"").gsub("\"value\"","\"expected\"",).gsub("/",".")
        end

        def self.compare_keys
            expected_json_keys = self.get_keys(@@expected_json.to_h).map(&:to_s)
            response_json_keys = self.get_keys(@@response_json.data.to_h).map(&:to_s)
            if(expected_json_keys.count > response_json_keys.count)
                return expected_json_keys - response_json_keys
            else
                return response_json_keys - expected_json_keys
            end
        end

        def self.get_keys(input_hash)
            arr = []
            input_hash.each do |key, value|
                arr << key
                arr << if value.is_a?(Array)
                    value.collect do |item|
                        get_keys(item) if item.is_a?(Hash)
                    end.compact.uniq
                elsif value.is_a?(Hash)
                    get_keys(value)
                end
            end
            return arr.compact.flatten
        end

    end
end