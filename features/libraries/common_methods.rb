class CommonMethods

  # Usage
  # CommonMethods.fetch_from_json("input_json", "relationshipManagers,0,clients,nodes,0,firstName")
  # Result = Munkong
  def self.fetch_from_json(input_json,path)
    begin
      result = input_json
      path = path.split(",")
      path.each do |value|
        begin
          Integer(value).is_a? Integer
          result = result.dig(value.to_i)
        rescue
          result = result.dig(value)
        end
      end
      return result.to_s
      rescue Exception => e
      #enable logger for this method - VT
      puts "Exception occured while fetch the error object in the response" + e.message
      return nil
    end
  end

  # Usage
  # CommonMethods.multifetch_from_json("input_json", "relationshipManagers,0,clients,nodes,$all$,firstName")
  # Result = ["Munkong", "Porpiang", "Naree", "Santisuk", "Wassana"]
  def self.multifetch_from_json(input_json,path)
    begin
      result = input_json
      result_array = []
      temp_val = ""
      path = path.split(",")
      current_path = path
      path.each do |value|
        if value == "$all$"
          current_path = current_path[1..-1]
          result.each do |each_hash|
            current_path.each do |val|
              begin
                Integer(val).is_a? Integer
                temp_val = each_hash.dig(val.to_i)
              rescue
                temp_val = each_hash.dig(val)
              end
            end
            result_array << temp_val
          end
          break
        end
        begin
          Integer(value).is_a? Integer
          result = result.dig(value.to_i)
          current_path = current_path[1..-1]
        rescue
          result = result.dig(value)
          current_path = current_path[1..-1]
        end
      end
      return result_array
      rescue Exception => e
      #enable logger for this method - VT
      puts "Exception occured while fetch the error object in the response "
      puts e.message
      puts e.backtrace
      return nil
    end
  end

end
