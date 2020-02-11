@TC_SA_Features
Feature: AdviseWealth | Investments Funds Queries

    @regression @sanity @TC_SA_First_Feature_001
    Scenario Outline:TS001 Sample graphql query with query variable and ignoring few values in comparison
        Given I set query variables
            | configKey              | configValue         |
            | fundsGeographies       | <geographies>       |
            | fundsCurrencies        | <currencies>        |
            | fundsAssetClasses      | <assetclasses>      |
            | fundsInvestmentBudget  | <investmentBudget>  |
            | fundsAnnualizedReturns | <annualizedReturns> |
        When I execute the query
            | Query    | QueryVariable |
            | sample   | sample        |
        Then I store the values from the response
            | VariableName | JsonPath   |
            | ID           | data,hello |
        And I ignore the few keys from comparison
            | IgnoreKeys   |
            | creatingDate |
        Then I validated the response as against stored validated JSON data
            | ValidatedJSONFile |
            | <output_json>     |

    Examples:
        | geographies             | currencies  | assetclasses        | investmentBudget                 | annualizedReturns                | output_json                                 |
        | US                      | empty       | empty               | empty                            | empty                            | $FundListOneGeographyResponse$              |
        | US,ASIA_EX_JAPAN,GLOBAL | empty       | empty               | empty                            | empty                            | $FundListMoreGeographyResponse$             |
        | empty                   | USD         | empty               | empty                            | empty                            | $FundListOneCurrencyResponse$               |
        | empty                   | USD,SGD,MYR | empty               | empty                            | empty                            | $FundListMoreCurrencyResponse$              |
        | empty                   | empty       | empty               | less_than_5K                     | empty                            | $FundListOneInvestmentBudgetResponse$       |
        | empty                   | empty       | empty               | less_than_5K,between_5K_and_100K | empty                            | $FundListMoreInvestmentBudgetResponse$      |
        | empty                   | empty       | FIXED_INCOME        | empty                            | empty                            | $FundListOneAssetClassResponse$             |
        | empty                   | empty       | FIXED_INCOME,EQUITY | empty                            | empty                            | $FundListMoreAssetClassResponse$            |
        | empty                   | empty       | empty               | empty                            | between_5_and_1                  | $FundListOneAnnualizedReturnsResponse$      |
        | empty                   | empty       | empty               | empty                            | between_1_and_5,between_5_and_10 | $FundListMoreAnnualizedReturnsResponse$     |
        | US                      | USD         | FIXED_INCOME        | less_than_5K                     | between_5_and_1                  | $FundListOneInEachCategoryResponse$         |
        | US,ASIA_EX_JAPAN,GLOBAL | USD,SGD,MYR | FIXED_INCOME,EQUITY | less_than_5K,between_5K_and_100K | between_1_and_5,between_5_and_10 | $FundListMoreThanOneInEachCategoryResponse$ |
