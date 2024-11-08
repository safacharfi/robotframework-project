*** Settings ***
Library           SeleniumLibrary

*** Variables ***
${URL}            http://127.0.0.1:5000/

*** Test Cases ***
Profile Update Test
    [Documentation]    Test updating the user profile
    Open Browser    ${URL}    chrome
    Input Text    name=username    testuser
    Input Text    name=password    password
    Click Button    xpath=//input[@type='submit']  # Login button
    Click Link    Profile
    Input Text    name=username    newtestuser  # Update the username
    Input Text    name=first_name    Jane
    Input Text    name=last_name    Smith
    Input Text    name=phone    987-654-3210
    Click Button    xpath=//button[contains(text(), 'Update Profile')]  # Updated this line
    Page Should Contain    Username updated successfully!
    Close Browser