@TC_SA_Features
Feature: Sample graphql query with variables example

    @regression @sanity @TC_SA_First_Feature_001
    Scenario Outline:TS001 Sample graphql query with query variable and ignoring few values in comparison
        Given I set query variables
            | configKey              | configValue         |
            | fundsGeographies       | <geographies>       |
            | fundsCurrencies        | <currencies>        |
            | fundsAssetClasses      | <assetclasses>      |
            | fundsInvestmentBudget  | <investmentBudget>  |
            | fundsAnnualizedReturns | <annualizedReturns> |
        When I execute the query "sample query"
            | Query    | QueryVariable |
            | sample   | sample        |
        Then I store the values from the response
            | VariableName      | JsonPath                                  |
            | isoCode           | data,instruments,nodes,0,currency,isoCode |
        Then I store the values from the response as global
            | VariableName      | JsonPath                                  |
            | isoCode           | data,instruments,nodes,0,currency,isoCode |
        Then I ignore the few keys from comparison
            | IgnoreKeys               |
            | wiCode                   |
            | strategicAssetAllocation |
        Then I validated the response as against stored validated JSON data
            | ExpectedJson      |
            | <expected_json>   |

    Examples:
        | geographies             | currencies  | assetclasses        | investmentBudget                 | annualizedReturns                | expected_json  |
        | US                      | empty       | empty               | empty                            | empty                            | sample         |
        | US,ASIA_EX_JAPAN,GLOBAL | empty       | empty               | empty                            | empty                            | sample1        |
        | empty                   | USD,SGD,MYR | empty               | empty                            | empty                            | sample2        |
        | empty                   | empty       | empty               | less_than_5K                     | empty                            | sample3        |
        | empty                   | empty       | empty               | less_than_5K,between_5K_and_100K | empty                            | sample4        |
        | empty                   | empty       | FIXED_INCOME        | empty                            | empty                            | sample5        |
        | empty                   | empty       | FIXED_INCOME,EQUITY | empty                            | empty                            | sample6        |
        | empty                   | empty       | empty               | empty                            | between_5_and_1                  | sample7        |
        | empty                   | empty       | empty               | empty                            | between_1_and_5,between_5_and_10 | sample8        |
        | US                      | USD         | FIXED_INCOME        | less_than_5K                     | between_5_and_1                  | sample9        |
