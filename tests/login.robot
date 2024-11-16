*** Settings ***
Library           SeleniumLibrary

*** Variables ***
${URL}            http://127.0.0.1:5000/

*** Test Cases ***
Valid Login Test
    [Documentation]    Test valid login credentials
    Open Browser    ${URL}    chrome
    Input Text    name=username    testuser
    Input Text    name=password    password
    Click Button    xpath=//input[@type='submit']
    Page Should Contain    Welcome, testuser!  # Check for dashboard content
    Close Browser

Invalid Login Test
    [Documentation]    Test invalid login credentials
    Open Browser    ${URL}    chrome
    Input Text    name=username    wronguser
    Input Text    name=password    wrongpassword
    Click Button    xpath=//input[@type='submit']
    Page Should Contain    Invalid credentials
    Close Browser
Invalid Username Test
    [Documentation]    Test invalid username
    Open Browser    ${URL}    chrome
    Input Text    name=username    wronguser
    Input Text    name=password    password
    Click Button    xpath=//input[@type='submit']
    Page Should Contain    Invalid credentials
    Close Browser

Invalid Password Test
    [Documentation]    Test invalid password
    Open Browser    ${URL}    chrome
    Input Text    name=username    testuser
    Input Text    name=password    wrongpassword
    Click Button    xpath=//input[@type='submit']
    Page Should Contain    Invalid credentials
    Close Browser

Dashboard Access Test
    [Documentation]    Test access to dashboard after valid login
    Open Browser    ${URL}    chrome
    Input Text    name=username    testuser
    Input Text    name=password    password
    Click Button    xpath=//input[@type='submit']
    Page Should Contain    Welcome, testuser!
    Page Should Contain    This is your dashboard.
    Click Link    Logout
    Close Browser

Logout Test
    [Documentation]    Test logout functionality
    Open Browser    ${URL}    chrome
    Input Text    name=username    testuser
    Input Text    name=password    password
    Click Button    xpath=//input[@type='submit']
    Click Link    Logout
    Page Should Contain    Login
    Close Browser