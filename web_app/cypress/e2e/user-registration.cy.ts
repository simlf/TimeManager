// describe('User Registration', () => {
//   beforeEach(() => {
//     cy.visit('/register')
//   })
//
//   it('should register a new user successfully and redirect to login', () => {
//     // Generate a unique username and email for each test run
//     const timestamp = Date.now()
//     const username = `user_${timestamp}`
//     const email = `${timestamp}@a.a`
//
//     // Fill out the registration form
//     cy.get('input[name="username"]').type(username)
//     cy.get('input[name="email"]').type(email)
//     cy.get('input[name="password"]').type('new_password')
//
//     // Submit the registration form
//     cy.get('button[type="submit"]').click()
//
//     // Assert that registration was successful
//     cy.get('.message').should('contain', 'User registered successfully')
//     // Assert that the URL has changed to the /login page
//     cy.url().should('include', '/login')
//   })
//
//   it('should register a new user successfully, redirect to login, logs in succesfully and is redirected to home page', () => {
//     // Generate a unique username and email for each test run
//     const timestamp = Date.now()
//     const username = `user_${timestamp}`
//     const email = `${timestamp}@a.a`
//
//     // Fill out the registration form
//     cy.get('input[name="username"]').type(username)
//     cy.get('input[name="email"]').type(email)
//     cy.get('input[name="password"]').type('new_password')
//
//     // Submit the registration form
//     cy.get('button[type="submit"]').click()
//
//     // Assert that registration was successful
//     cy.get('.message').should('contain', 'User registered successfully')
//     // Assert that the URL has changed to the /login page
//     cy.url().should('include', '/login')
//
//     cy.get('input[name="email"]').type(email)
//     cy.get('input[name="password"]').type('new_password')
//
//     cy.get('button[type="submit"]').click()
//     cy.get('.message').should('contain', 'User logged in  successfully')
//     cy.url().should('include', '/')
//   })
//
//   it('should display an error message for a password to short', () => {
//     // Fill out the registration form with invalid data
//     cy.get('input[name="username"]').type('invalid_user')
//     cy.get('input[name="email"]').type('newuser1@example.com')
//     cy.get('input[name="password"]').type('short')
//
//     // Submit the registration form
//     cy.get('button[type="submit"]').click()
//
//     // Assert that the email input field has the "error" class
//     cy.get('.message').should(
//       'contain',
//       'Error registering user, your password should be at least 6 characters long and the email should be less than 20 characters long'
//     )
//   })
// })
