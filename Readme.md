# Graber - Ruby

Graber is a framework for Graphql automation using Cucumber in Ruby language. Graphql automation can be done just by defining the query, query variable and other requirements from cucumber's feature file itself. All the core logics are covered in step definition file. Graber also includes snap feature which helps to replace the exisiting JSON's (which is used to compare with the response JSON) with the new response JSON's. This helps greatly in data centric applications.

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](LICENSE)
[![Made with Ruby](https://img.shields.io/badge/Made%20with-Ruby-red.svg)](https://www.ruby-lang.org/en/)
[![StackOverflow](http://img.shields.io/badge/Stack%20Overflow-Ask-blue.svg)]( https://stackoverflow.com/users/10505289/naresh-sekar )
[![Contributions Welcome](https://img.shields.io/badge/Contributions-Welcome-brightgreen.svg)](CONTRIBUTING.md)
[![email me](https://img.shields.io/badge/Contact-Email-green.svg)](mailto:nareshnavinash@gmail.com)


![alt text](features/libraries/Graber-Ruby.png)


## Supports
* Graphql automation
* No code scripting
* Allure reports
* Jenkins Integration
* Modes of run via CLI command
* Headless run
* Snap feature to change test data in one shot

## Setup
* Clone this repository
* Navigate to the cloned folder
* Install bundler using `gem install bundler`
* Install the dependencies by `bundle install`

## To Run the tests
For a simple run of all the feature files in normal mode, try
```
cucumber
```
To Run the tests in Snap mode for the available feature files, try

```
cucumber snap=1
```
This will take the response JSON and save it to the test data file if any of the test case failed. Be cautious while using this mode and never commit the changes made after this run blindly. This mode will change only the files available in the `graphql/expected_jsons` folder and will never change any other files in the project.

To Run the tests in snap mode along with tags, try
```
cucumber -t "@scenario_001" snap=1
```

## To open allure results
Allure is a open source framework for reporting the test runs. To install allure in mac, use the following steps

```
brew cask install adoptopenjdk
brew install allure
```

To open the generated allure results,

```
allure serve reports/allure
```

## Jenkins Integration with Docker images
Get any of the linux with ruby docker image as the slaves in jenkins and use the same for executing the UI automation with this framework (Sample docker image - `https://hub.docker.com/_/ruby`). From the jenkins bash Execute the following to get the testcases to run,
```
#!/bin/bash -l
rvm list
ls
cd <path_to_the_project>
bundle install
cucumber #or custom commands
```
for complete guide to setup in linux check [Cloud Setup for Ruby](https://github.com/nareshnavinash/Cloud-Setup-Ruby)

In Jenkins pipeline, try to add the following snippet to execute the tests,
```
pipeline {
    agent { docker { image 'ruby' } }
    stages {
        stage('build') {
            steps {
                sh 'cd project/'
                sh 'gem install bundler'
                sh 'bundle install'
                sh 'cucumber' # or custom methods
            }
        }
    }
}
```

## Break down into end to end tests

## Defining Query, Query Variable and Response files

For all the test case it is mandatory to create a file for query file and a response file. If the query needs query variable then it is mandatory to create variable file.

### Query file

Create a file with `.graphql` extention inside the folder `graphql/query`and place the graphql query inside it. The query should be a working one and we should not have custom name next to the `query` term. Even for mutation same rule applies.

```
query{
    customer(searchkey: "na"){
        firstname
        lastname
    }
}
```

```
mutation{
    createcustomer(firstname: "Naresh", lastname: "Sekar"){
        id
        createddate
    }
}
```

### Query Variable file

If a query is in need of variables that is to be passed, we need to create a JSON file under `graphql/variable` folder and have the query variables inside it. For static query variable directly mention the values inside the variable JSON file. For dynamic query variable (variable which will be given through feature file) give the dynamic variable name with prefix `$`.

#### For static Query Variable
For static query variable following structure would be enough to automate.

Query:
```
query($searchkey: String!){
    customer(searchkey: $searchkey){
        firstname
        lastname
    }
}
```
Variable:
```
{
    "searchkey": "na"
}
```

#### For Dynamic Query Variable
For dynamic query variable one has to undergo the following steps to give the variable from feature file.

Query:
```
query($searchkey: String!){
    customer(searchkey: $searchkey){
        firstname
        lastname
    }
}
```
Variable:
```
{
    "searchkey": "$dynamicValueFromFeatureFile"
}
```
Scenario Feature File:
```
Scenario: Sample plain query automation
    Given I set query variables
        | configKey                     | configValue         |
        | dynamicValueFromFeatureFile   | na                  |
    When ...
    Then ... 
```
Scenario Outline Feature File:
```
Scenario Outline: Sample single query multi variable automation
    Given I set query variables
        | configKey                     | configValue         |
        | dynamicValueFromFeatureFile   | <searchKey>         |
    When ...
    Then ... 

    Examples:
        | searchKey |
        | na        |
        | ua        |
        | ka        |
```
In the above example, same query will run three times with the search key mentioned in the examples section. Thus reducing an ample amount of time in creating multiple query variable files for a single query.

### Response file:

Create a response file under `graphql/expected_jsons` folder and place the expected json for a query. Use this file in the feature file to compare and with the query response.

For Scenario Feature File:
```
Given ...
When ...
Then I validated the response as against stored validated JSON data
    | ExpectedJson      |
    | sample            |
```

For Scenario Outline feature file:
```
Given ...
When ...
Then I validated the response as against stored validated JSON data
    | ExpectedJson      |
    | <response_file>   |

Examples:
    | response_file |
    | sample        |
    | sample1       |
    | sample2       |
```

## Defining the feature file:

Once Query, Variable and Response files are created, we need to start defining the feature file. No code is involded here, just mapping of query file, variable file and the response file. In addition to that some of the additional steps are added.

Simple Scenario:
```
Scenario: Simple query only scenario
    When I execute the query "sample query"
        | Query    |
        | sample   |
    Then I validated the response as against stored validated JSON data
        | ExpectedJson |
        | sample       |
```

Simple Scenario with query and variable
```
Scenario: Simple query with variable scenario
    When I execute the query "sample query"
        | Query    | QueryVariable |
        | sample   | sample        |
    Then I validated the response as against stored validated JSON data
        | ExpectedJson |
        | sample       |
```

Scenario outline with query and variable scenario:
```
Scenario Outline: Sample graphql query with query variable in scenario outline design
    Given I set query variables
        | configKey              | configValue         |
        | dynamicvariable1       | <dynamicvariable1>  |
    When I execute the query "sample query"
        | Query    | QueryVariable |
        | sample   | sample        |
    Then I validated the response as against stored validated JSON data
        | ExpectedJson      |
        | <expected_json>   |
    
    Examples:
        | dynamicvariable1 | expected_json |
        | var1             | sample1       |
        | var2             | sample2       |
        | var3             | sample3       |
```

Scenario outline with query and variable and looping through with the value from the response scenario:
```
Scenario Outline: Sample graphql query with query variable in scenario outline design
    Given I set query variables
        | configKey              | configValue         |
        | dynamicvariable1       | <dynamicvariable1>  |
    When I execute the query "sample query"
        | Query    | QueryVariable |
        | sample   | sample        |
    Then I store the values from the response
        | VariableName             | JsonPath                                  |
        | dynamicvariable_runtime  | data,instruments,nodes,0,currency,isoCode |
    Then I validated the response as against stored validated JSON data
        | ExpectedJson      |
        | <expected_json>   |
    
    Examples:
        | dynamicvariable1 | expected_json |
        | var1             | sample1       |
        | var2             | sample2       |
        | var3             | sample3       |
```

Scenario Outline with query, variable and validating response by ignoring some keys in the comparison:
```
Scenario Outline: Sample graphql query with query variable in scenario outline design
    Given I set query variables
        | configKey              | configValue         |
        | dynamicvariable1       | <dynamicvariable1>  |
    When I execute the query "sample query"
        | Query    | QueryVariable |
        | sample   | sample        |
    Then I store the values from the response
        | VariableName             | JsonPath                                  |
        | dynamicvariable_runtime  | data,instruments,nodes,0,currency,isoCode |
    Then I ignore the few keys from comparison
        | IgnoreKeys               |
        | ignore_key1              |
        | ignore_key2              |
    Then I validated the response as against stored validated JSON data
        | ExpectedJson      |
        | <expected_json>   |
    
    Examples:
        | dynamicvariable1 | expected_json |
        | var1             | sample1       |
        | var2             | sample2       |
        | var3             | sample3       |
```

## First time test case creation

While creating the test cases for the first time, we no need to create the expected json file for all the cases. Just create Query file, Query Variable file and then draft the Scenario Outline and then run the test with `snap=1`, this will automatically create the expected JSON files in the `graphql/expected_jsons` folder. Review the changes and then commit.

Note: Query added in this project structure is dummy query and the endpoint is also a mock one. Kindly try with your own query and endpoint.

## Built With

* [Cucumber](https://rubygems.org/gems/cucumber/versions/3.1.2) - Automation core framework
* [Graphql_Client](https://github.com/github/graphql-client) - Client used to do Graphql actions
* [Allure Cucumber](https://rubygems.org/gems/allure-cucumber/versions/0.6.1) - For Detailed reporting.

## Contributing

1. Clone the repo!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Create a pull request.

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on code of conduct, and the process for submitting pull requests.

## Authors

* **[Naresh Sekar](https://github.com/nareshnavinash)**

## License

This project is licensed under the GNU GPL-3.0 License - see the [LICENSE](LICENSE) file for details

## Acknowledgments

* To all the open source contributors whose code has been referred in this project.
