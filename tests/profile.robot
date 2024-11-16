*** Settings ***
Library           SeleniumLibrary

*** Variables ***
${URL}            http://127.0.0.1:5000/

*** Test Cases ***
Profile Displaying Test
    [Documentation]    Test the user profile displaying
    Open Browser    ${URL}    chrome
    Input Text    name=username    testuser
    Input Text    name=password    password
    Click Button    xpath=//input[@type='submit']
    Click Link    Profile

    Page Should Contain    User Profile

    Close Browser

Profile Update Test
    [Documentation]    Test updating the user profile
    Open Browser    ${URL}    chrome
    Input Text    name=username    testuser
    Input Text    name=password    password
    Click Button    xpath=//input[@type='submit']
    Click Link    Profile
    Wait Until Element Is Visible    xpath=//a[text()='Edit Profile']    timeout=10s
    Click Link    xpath=//a[text()='Edit Profile']

    Input Text    name=username    safacharfi
    Input Text    name=first_name    safa
    Input Text    name=last_name    charfi
    Input Text    name=phone    987-654-3210
    Wait Until Element Is Visible    xpath=//button[text()='Update Profile']    timeout=10s
    Click Button    xpath=//button[text()='Update Profile']
    Sleep    1

    Page Should Contain    User Profile
    Close Browser


Profile Update Test Without username
    [Documentation]    Test updating the user profile without username
    Open Browser    ${URL}    chrome
    Input Text    name=username    testuser
    Input Text    name=password    password
    Click Button    xpath=//input[@type='submit']
    Click Link    Profile
    Wait Until Element Is Visible    xpath=//a[text()='Edit Profile']    timeout=10s
    Click Link    xpath=//a[text()='Edit Profile']

    Input Text    name=username    ${empty}
    Input Text    name=first_name    safa
    Input Text    name=last_name    charfi
    Input Text    name=phone    987-654-3210
    Wait Until Element Is Visible    xpath=//button[text()='Update Profile']    timeout=10s
    Click Button    xpath=//button[text()='Update Profile']
    Sleep    1

    Page Should Contain    Edit Profile

    Close Browser


Profile Update Test Without first_name
    [Documentation]    Test updating the user profile without firstname
    Open Browser    ${URL}    chrome
    Input Text    name=username    testuser
    Input Text    name=password    password
    Click Button    xpath=//input[@type='submit']
    Click Link    Profile
    Wait Until Element Is Visible    xpath=//a[text()='Edit Profile']    timeout=10s
    Click Link    xpath=//a[text()='Edit Profile']

    Input Text    name=username    safacharfi
    Input Text    name=first_name    ${empty}
    Input Text    name=last_name    charfi
    Input Text    name=phone    987-654-3210
    Wait Until Element Is Visible    xpath=//button[text()='Update Profile']    timeout=10s
    Click Button    xpath=//button[text()='Update Profile']
    Sleep    1

    Page Should Contain    Edit Profile

    Close Browser

Profile Update Test Without last_name
    [Documentation]    Test updating the user profile without lastname
    Open Browser    ${URL}    chrome
    Input Text    name=username    testuser
    Input Text    name=password    password
    Click Button    xpath=//input[@type='submit']
    Click Link    Profile
    Wait Until Element Is Visible    xpath=//a[text()='Edit Profile']    timeout=10s
    Click Link    xpath=//a[text()='Edit Profile']

    Input Text    name=username    safacharfi
    Input Text    name=first_name    safa
    Input Text    name=last_name    ${empty}
    Input Text    name=phone    987-654-3210
    Wait Until Element Is Visible    xpath=//button[text()='Update Profile']    timeout=10s
    Click Button    xpath=//button[text()='Update Profile']
    Sleep    1

    Page Should Contain    Edit Profile

    Close Browser

Profile Update Test Without phone number
    [Documentation]    Test updating the user profile without lphone number
    Open Browser    ${URL}    chrome
    Input Text    name=username    testuser
    Input Text    name=password    password
    Click Button    xpath=//input[@type='submit']
    Click Link    Profile
    Wait Until Element Is Visible    xpath=//a[text()='Edit Profile']    timeout=10s
    Click Link    xpath=//a[text()='Edit Profile']

    Input Text    name=username    safacharfi
    Input Text    name=first_name    safa
    Input Text    name=last_name    charfi
    Input Text    name=phone    ${empty}
    Wait Until Element Is Visible    xpath=//button[text()='Update Profile']    timeout=10s
    Click Button    xpath=//button[text()='Update Profile']
    Sleep    1

    Page Should Contain    Edit Profile

    Close Browser