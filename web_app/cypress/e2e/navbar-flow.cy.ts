describe('NavBar Tests', () => {

  // it('should have a "Your Profile" link in the NavBar for authenticated users', () => {
  //   cy.fixture('users/employee.json').then((userData) => {
  //     // Assuming that you have a command to login
  //     cy.login(userData.email, userData.password)
  //     cy.get('#headlessui-menu-button-3 > .absolute').should('be.visible').click()
  //     cy.contains('Your Profile').should('be.visible')
  //     cy.contains('Your Group').should('not.exist')
  //   })
  // })

  it('should have a button "Your Group" in the NavBar as a manager', () => {
    cy.fixture('users/manager.json').then((userData) => {
      cy.login(userData.email, userData.password)
      cy.get('#headlessui-menu-button-3 > .absolute').should('be.visible').click()
      cy.contains('Your Profile').should('be.visible')
      cy.contains('Your Group').should('be.visible')
    })
  })

  it('should have a button "Your Group" in the NavBar as a super manager', () => {
    cy.fixture('users/supermanager.json').then((userData) => {
      cy.login(userData.email, userData.password)
      cy.get('#headlessui-menu-button-3 > .absolute').should('be.visible').click()
      cy.contains('Your Profile').should('be.visible')
      cy.contains('Your Group').should('be.visible')
    })
  })

  // it('should have common navigation links for all authenticated users', () => {
  //   const users = ['employee.json', 'manager.json', 'supermanager.json'];
  //   users.forEach(userFixture => {
  //     cy.fixture(`users/${userFixture}`).then((userData) => {
  //       cy.login(userData.email, userData.password)
  //       cy.get('nav').contains('Home').should('be.visible')
  //       cy.get('nav').contains('Clock Manager').should('be.visible')
  //       cy.get('nav').contains('Working Times').should('be.visible')
  //
  //       cy.get('#headlessui-menu-button-3 > .absolute').should('be.visible').click()
  //       cy.get('nav').contains('Sign out').should('be.visible')
  //     })
  //   })
  // })

  // it('should only display login button when no user is authenticated', () => {
  //   cy.visit('/')
  //   // Check if login button is visible
  //   cy.get('nav').contains('Login').should('be.visible')
  //   // Check if authenticated user links are not present
  //   cy.get('#headlessui-menu-button-3 > .absolute').should('not.exist')
  //   cy.get('nav').contains('Your Profile').should('not.exist')
  //   cy.get('nav').contains('Your Group').should('not.exist')
  //   cy.get('nav').contains('Sign out').should('not.exist')
  // })
})
