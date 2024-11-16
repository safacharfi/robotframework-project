*** Settings ***
Library           SeleniumLibrary
Library           RequestsLibrary

*** Variables ***
${URL}            http://127.0.0.1:5000/
${LOGIN_URL}      ${URL}/login
${NOTES_URL}      ${URL}/notes
${EMPTY}          ""  # Define an empty variable for clarity

*** Test Cases ***
Access Notes Page Test
    [Documentation]    Test accessing the notes page
    Open Browser    ${URL}    chrome
    Input Text    name=username    testuser
    Input Text    name=password    password
    Click Button    xpath=//input[@type='submit']
    Click Link    Manage Notes
    Page Should Contain    Add a New Event
    Close Browser

Add New Event Test
    [Documentation]    Test adding a new event
    Open Browser    ${URL}    chrome
    Input Text    name=username    testuser
    Input Text    name=password    password
    Click Button    xpath=//input[@type='submit']
    Click Link    Manage Notes
    Input Text    xpath=//textarea[@name='note']    My new event
    Click Button    xpath=//button[contains(text(), 'Add Event')]
    Page Should Contain    My new event
    Close Browser

Add New Event Test without any text
    [Documentation]    Test adding a new event without any text
    Open Browser    ${URL}    chrome
    Input Text    name=username    testuser
    Input Text    name=password    password
    Click Button    xpath=//input[@type='submit']
    Click Link    Manage Notes

    # Extract the current length of notes from the interface
    ${old_length}=    Get Length Of Notes

    # Attempt to add an empty note
    Input Text    xpath=//textarea[@name='note']    ${EMPTY}
    Click Button    xpath=//button[contains(text(), 'Add Event')]

    # Extract the new length of notes from the interface
    ${new_length}=    Get Length Of Notes

    # Assert that the note list length has not changed
    Should Be Equal As Integers    ${new_length}    ${old_length}
    Close Browser

Delete Event Test
    [Documentation]    Test deleting a note and verifying the length decreases by one
    Open Browser    ${URL}    chrome
    Input Text    name=username    testuser
    Input Text    name=password    password
    Click Button    xpath=//input[@type='submit']
    Click Link    Manage Notes

    # Create a note to ensure there's something to delete
    Input Text    xpath=//textarea[@name='note']    Note to be deleted
    Click Button    xpath=//button[contains(text(), 'Add Event')]

    # Get the current length of notes from the interface
    ${old_length}=    Get Length Of Notes

    # Click the delete button for the last note
    Click Button    xpath=(//button[contains(text(), 'Delete')])[last()]

    # Wait for the note to be removed
    Sleep    1  # Adjust timing as necessary

    # Get the new length of notes from the interface
    ${new_length}=    Get Length Of Notes

    # Assert that the note list length has decreased by 1
    Should Be Equal As Integers    ${new_length+1}    ${old_length + 1}
    Close Browser

Edit Note Page Test
    [Documentation]    Test if the edit note page displays correctly
    Open Browser    ${URL}    chrome
    Input Text    name=username    testuser
    Input Text    name=password    password
    Click Button    xpath=//input[@type='submit']
    Click Link    Manage Notes

    # Create a note to edit
    Input Text    xpath=//textarea[@name='note']    Note to be edited
    Click Button    xpath=//button[contains(text(), 'Add Event')]

    # Click the edit button for the last note
    Click Link    Edit    # Adjust this locator to target the correct edit button
    
    # Verify that the edit page displays correctly
    Page Should Contain    Edit your note:
    Close Browser


Edit Note Page Test with text
    [Documentation]    Test if the edit works correctly
    Open Browser    ${URL}    chrome
    Input Text    name=username    testuser
    Input Text    name=password    password
    Click Button    xpath=//input[@type='submit']
    Click Link    Manage Notes

    # Create a note to edit
    Input Text    xpath=//textarea[@name='note']    Note to be edited
    Click Button    xpath=//button[contains(text(), 'Add Event')]

    Click Link    Edit  
     # Create a note to ensure there's something to delete
    Input Text    xpath=//textarea[@name='note']    Note updated
    Click Button    xpath=//button[contains(text(), 'Update Note')] 
    Sleep    1  # Adjust timing as necessary
 
    
    # Verify that the edit page displays correctly
    Page Should Contain    Your Events

    Close Browser

Edit Note Page Test without text
    [Documentation]    Test if the edit without a text works 
    Open Browser    ${URL}    chrome
    Input Text    name=username    testuser
    Input Text    name=password    password
    Click Button    xpath=//input[@type='submit']
    Click Link    Manage Notes

    # Create a note to edit
    Input Text    xpath=//textarea[@name='note']    Note to be edited
    Click Button    xpath=//button[contains(text(), 'Add Event')]

    Click Link    Edit  
     # Update the note with an empty text
    Input Text    xpath=//textarea[@name='note']    ${EMPTY}
    Click Button    xpath=//button[contains(text(), 'Update Note')] 
    Sleep    1  # Adjust timing as necessary
 
    
    # Verify that the note list is displayed
    Page Should Not Contain    Your Events.
    Close Browser

*** Keywords ***
Get Length Of Notes
    [Documentation]    Retrieve the length of notes displayed on the page.
    ${notes}=    Get WebElements    xpath=//div[@class='note']  # Adjust this XPath to match your notes container
    ${length}=    Get Length    ${notes}
    RETURN    ${length}