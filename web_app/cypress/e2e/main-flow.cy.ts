describe('Main Flow', () => {
  beforeEach(() => {
    cy.fixture('users/employee.json').then((userData) => {
      cy.login(userData.email, userData.password)
    })
  })

  it('should navigate to the home page', () => {
    cy.url().should('eq', Cypress.config().baseUrl + '/')
  })

  it('should not have the Login button on the NavBar when logged in', () => {
    cy.get('nav').should('not.contain', 'Login')
  })

  it('should click on the Clock Manager button on the NavBar and redirect to /clockManager/:username', () => {
    cy.get('nav').contains('Clock Manager').should('be.visible').wait(2000).click()

    cy.fixture('users/employee.json').then((userData) => {
      const expectedUrl = `/clockManager/${userData.username.replace(/ /g, '%20')}`
      cy.log('Expected URL:', expectedUrl)

      cy.url().should('include', expectedUrl)
    })
  })

  it('should click on Working Times button on the NavBar and redirect to /workingTimes/:userId', () => {
    cy.get('nav').contains('Working Times').should('be.visible').wait(2000).click()

    cy.fixture('users/employee.json').then((userData) => {
      const expectedUrl = `/workingTimes/${userData.id}`
      cy.log('Expected URL:', expectedUrl)

      cy.url().should('include', expectedUrl)
    })
  })

  it('should start a clock manager, take a break and stop', () => {
    cy.fixture('users/employee.json').then((userData) => {
      cy.visit(`/clockManager/${userData.username.replace(/ /g, '%20')}`)
      cy.contains('Start').should('be.visible').wait(1000).click()

      cy.contains('Break Time').should('be.visible').wait(1000).click()

      cy.contains('Stop').should('be.visible').wait(1000).click()
    })
  })

  it('should start a clock manager, take a break, go back to work and stop', () => {
    cy.fixture('users/employee.json').then((userData) => {
      cy.visit(`/clockManager/${userData.username.replace(/ /g, '%20')}`)
      cy.contains('Start').should('be.visible').wait(3000).click()

      cy.contains('Break Time').should('be.visible').wait(3000).click()

      cy.contains('Back to work').should('be.visible').wait(1000).click()

      cy.contains('Stop').should('be.visible').wait(3000).click()
    })
  })
})
