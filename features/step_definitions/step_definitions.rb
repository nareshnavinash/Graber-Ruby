include Graber

Given("I set query variables") do |table|
    table.rows.each do |data|
        @@runtime_variables[data[0]] = data[1]
    end
end

When("I execute the query {string}") do |string, table|
    table.rows.each do |data|
        if data.count == 1
            graphql_file = FileHelper.read_graphql_file("#{data[0]}.graphql")
            Query = GqlHelper.parse(graphql_file)
            (Query == nil).should eql(false), "Error occured while parsing the query in file: #{data[0]}"
            result = GqlHelper.execute(Query)
            (result == nil).should eql(false), "Response is nil"
        elsif data.count == 2
            graphql_file = FileHelper.read_graphql_file("#{data[0]}.graphql")
            variable_file = FileHelper.read_query_variable_json_file("#{data[1]}.json")
            Query = GqlHelper.parse(graphql_file)
            (Query == nil).should eql(false), "Error occured while parsing the query in file: #{data[0]} with variable file: #{data[1]}"
            result = GqlHelper.execute(Query, variable_file)
            (result == nil).should eql(false), "Response is nil"
        end
    end
end

Then("I store the values from the response as global") do |table|
    table.rows.each do |data|
        @@global_response_data[data[0]] = CommonMethods.fetch_from_json(@@response_json,data[1])
    end
end

Then("I store the values from the response") do |table|
    table.rows.each do |data|
        @@runtime_variables[data[0]] = CommonMethods.fetch_from_json(@@response_json,data[1])
    end
end

Then("I ignore the few keys from comparison") do |table|
    table.rows.each do |data|
        @@exclude_keys << data
    end
end

Then("I validated the response as against stored validated JSON data") do |table|
    table.rows.each do |data|
        if ENV['snap'] == "1"
            all_files = Dir["#{Pathname.pwd}/graphql/expected_jsons/**/*.json"]
            File.open("#{Dir.pwd}/graphql/expected_jsons/#{data[0]}.json", "w") {|f| f.write("{}") } unless all_files.any? { |s| s.include?("#{data[0]}.json")}
        end
        expected_json = FileHelper.read_expected_json_file("#{data[0]}.json")
        (JsonHelper.bool_data_compare).should eql(true), "#{JsonHelper.string_data_compare}"
        binding.pry
    end
    @@exclude_keys = []
end