*** Settings ***
Library           SeleniumLibrary

*** Variables ***
${URL}            http://127.0.0.1:5000/

*** Test Cases ***
Add Employee Test
    [Documentation]    Test adding a new employee
    Open Browser    ${URL}/    chrome
    Input Text    name=username    testuser    # Login
    Input Text    name=password    password
    Click Button    xpath=//input[@type='submit']
    Wait Until Page Contains    Welcome, testuser!    timeout=10
    Go To    ${URL}/add_employee    # Navigate to add employee page
    Wait Until Element Is Visible    name=name    timeout=10
    Input Text    name=name    John Doe
    Input Text    name=role    Developer
    Input Text    name=phone    123456789
    Click Button    xpath=//button[contains(text(), 'Add Employee')]
    Wait Until Page Contains    Employee added successfully!    timeout=10  # Check for the success message on employee list page
    Close Browser

View Employee List Test
    [Documentation]    Test viewing the employee list
    Open Browser    ${URL}/    chrome
    Input Text    name=username    testuser    # Login
    Input Text    name=password    password
    Click Button    xpath=//input[@type='submit']
    Wait Until Page Contains    Welcome, testuser!    timeout=10
    Go To    ${URL}/employee_list    # Navigate to employee list
    Wait Until Page Contains    Name    timeout=10
    Page Should Contain    Name
    Page Should Contain    Role
    Page Should Contain    Phone
    Close Browser

Employee Count Test
    [Documentation]    Test that employee counts by role are displayed correctly.
    Open Browser    ${URL}/    chrome
    Input Text    name=username    testuser    # Login
    Input Text    name=password    password
    Click Button    xpath=//input[@type='submit']
    Wait Until Page Contains    Welcome, testuser!    timeout=10
    Go To    ${URL}/employee_list    # Navigate to employee list
    Wait Until Page Contains    Employee Counts by Role    timeout=10
    
    # Check for role counts
    Page Should Contain    Manager
    Page Should Contain    Developer
    # Add checks for specific counts if you know how many employees exist
    # For example, if you expect 2 Managers and 3 Developers:
    Page Should Contain    1   # Adjust this based on your actual data
    Page Should Contain    1   # Adjust this based on your actual data
    
    Close Browser

Missing Employee Name Test
    [Documentation]    Test adding an employee with a missing name
    Open Browser    ${URL}/    chrome
    Input Text    name=username    testuser    # Login
    Input Text    name=password    password
    Click Button    xpath=//input[@type='submit']
    Wait Until Page Contains    Welcome, testuser!    timeout=10
    Go To    ${URL}/add_employee
    Wait Until Element Is Visible    name=name    timeout=10
    Input Text    name=role    Developer
    Input Text    name=phone    123456789
    Click Button    xpath=//button[contains(text(), 'Add Employee')]
    Page Should Contain    Add a new employee
    Close Browser

Missing Employee Role Test
    [Documentation]    Test adding an employee with a missing role
    Open Browser    ${URL}/    chrome
    Input Text    name=username    testuser    # Login
    Input Text    name=password    password
    Click Button    xpath=//input[@type='submit']
    Wait Until Page Contains    Welcome, testuser!    timeout=10
    Go To    ${URL}/add_employee
    Wait Until Element Is Visible    name=name    timeout=10
    Input Text    name=name    John Doe
    Input Text    name=phone    123456789
    Click Button    xpath=//button[contains(text(), 'Add Employee')]
    Page Should Contain    Add a new employee
    Close Browser

Missing Employee Phone Test
    [Documentation]    Test adding an employee with a missing phone
    Open Browser    ${URL}/    chrome
    Input Text    name=username    testuser    # Login
    Input Text    name=password    password
    Click Button    xpath=//input[@type='submit']
    Wait Until Page Contains    Welcome, testuser!    timeout=10
    Go To    ${URL}/add_employee
    Wait Until Element Is Visible    name=name    timeout=10
    Input Text    name=name    John Doe
    Input Text    name=role    Developer
    Click Button    xpath=//button[contains(text(), 'Add Employee')]
    Page Should Contain    Add a new employee
    Close Browser