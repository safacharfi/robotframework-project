*** Settings ***
Library           SeleniumLibrary

*** Variables ***
${URL}            http://127.0.0.1:5000/

*** Test Cases ***
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


