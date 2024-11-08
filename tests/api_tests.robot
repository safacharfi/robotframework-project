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

Add Note Test
    [Documentation]    Test adding a note
    Open Browser    ${URL}    chrome
    Input Text    name=username    testuser
    Input Text    name=password    password
    Click Button    xpath=//input[@type='submit']
    Input Text    name=note    My first note
    Click Button    xpath=//input[@type='submit']
    Page Should Contain    Note added successfully!
    Page Should Contain    My first note
    Close Browser

Delete Note Test
    [Documentation]    Test deleting a note
    Open Browser    ${URL}    chrome
    Input Text    name=username    testuser
    Input Text    name=password    password
    Click Button    xpath=//input[@type='submit']
    Input Text    name=note    Note to be deleted
    Click Button    xpath=//input[@type='submit']
    # Use a specific selector to delete the note
    Click Button    xpath=//button[contains(text(), 'Delete')][last()]  # Adjusted to ensure the last note is targeted
    Page Should Contain    Note deleted successfully!
    Close Browser

Edit Note Test
    [Documentation]    Test editing a note
    Open Browser    ${URL}    chrome
    Input Text    name=username    testuser
    Input Text    name=password    password
    Click Button    xpath=//input[@type='submit']
    Input Text    name=note    My note to edit
    Click Button    xpath=//input[@type='submit']
    Click Link    Edit
    Input Text    name=note    My updated note
    Click Button    xpath=//input[@type='submit']
    Page Should Contain    Note updated successfully!
    Page Should Contain    My updated note
    Close Browser

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