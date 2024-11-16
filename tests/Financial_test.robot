*** Settings ***
Library           RequestsLibrary

*** Variables ***
${BASE_URL}      http://127.0.0.1:5000

*** Test Cases ***
Test Correct Financial Calculation
    [Documentation]    Test the financial calculation function with correct values
    ${response}=    GET    ${BASE_URL}/get_financial_data
    Should Be Equal As Numbers    ${response.json()['total_revenue']}    100000
    Should Be Equal As Numbers    ${response.json()['total_expenses']}    80000
    ${expected_balance}=    Evaluate    100000 - 80000
    Should Be Equal As Numbers    ${expected_balance}    ${response.json()['net_profit']}

Test Incorrect Financial Calculation
    [Documentation]    Test the financial calculation function with incorrect expected values
    ${response}=    GET    ${BASE_URL}/get_financial_data
    ${expected_incorrect}=    Set Variable    800
    Should Not Be Equal As Numbers    ${expected_incorrect}    ${response.json()['net_profit']}

Test Zero Values
    [Documentation]    Test the financial calculation with zero earnings and expenses
    ${earnings}=    Set Variable    0
    ${expenses}=    Set Variable    0
    ${expected_balance}=    Evaluate    ${earnings} - ${expenses}
    Should Be Equal As Numbers    ${expected_balance}    0

Test Negative Earnings
    [Documentation]    Test the financial calculation with negative earnings
    ${earnings}=    Set Variable    -500
    ${expenses}=    Set Variable    1000
    ${expected_balance}=    Evaluate    ${earnings} - ${expenses}
    Should Be Equal As Numbers    ${expected_balance}    -1500

Test Large Values
    [Documentation]    Test the financial calculation with large earnings and expenses
    ${earnings}=    Set Variable    1000000000
    ${expenses}=    Set Variable    500000000
    ${expected_balance}=    Evaluate    ${earnings} - ${expenses}
    Should Be Equal As Numbers    ${expected_balance}    500000000