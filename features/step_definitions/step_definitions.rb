include Graber

Given("I set query variables") do |table|
    @@runtime_variables = {}
    table.rows.each do |data|
        @@runtime_variables[data[0]] = data[1]
    end
end

When("I execute the query") do |table|
    # table is a Cucumber::MultilineArgument::DataTable
    pending # Write code here that turns the phrase above into concrete actions
end

Then("I store the values from the response") do |table|
    # table is a Cucumber::MultilineArgument::DataTable
    pending # Write code here that turns the phrase above into concrete actions
end

Then("I ignore the few keys from comparison") do |table|
    # table is a Cucumber::MultilineArgument::DataTable
    pending # Write code here that turns the phrase above into concrete actions
end

Then("I validated the response as against stored validated JSON data") do |table|
    # table is a Cucumber::MultilineArgument::DataTable
    pending # Write code here that turns the phrase above into concrete actions
end