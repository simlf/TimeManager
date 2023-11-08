describe('Main Flow', () => {
  beforeEach(() => {
    // Load user data and log in before each test
    cy.fixture('users/employee.json').then((userData) => {
      cy.login(userData.email, userData.password)
    })
  })

  it('should click on the Start button of the Clock Manager', () => {
    cy.fixture('users/employee.json').then((userData) => {
      cy.visit(`/clockManager/${userData.username.replace(/ /g, '%20')}`)
      cy.contains('Start').should('be.visible').wait(1000).click()
    })
  })

  it('should click on the Break time button of the Clock Manager', () => {
    cy.fixture('users/employee.json').then((userData) => {
      cy.visit(`/clockManager/${userData.username.replace(/ /g, '%20')}`)
      cy.contains('Break Time').should('be.visible').wait(1000).click()
      cy.wait(1000)
    })
  })

  it('should click on the Stop button of the Clock Manager', () => {
    cy.fixture('users/employee.json').then((userData) => {
      cy.visit(`/clockManager/${userData.username.replace(/ /g, '%20')}`)
      cy.contains('Stop').should('be.visible').wait(1000).click()
    })
  })

  it('should navigate to the home page', () => {
    // Wait for the navigation to the home page to be complete
    cy.url().should('eq', Cypress.config().baseUrl + '/')
  })

  it('should not have the Login button on the NavBar when logged in', () => {
    cy.get('nav').should('not.contain', 'Login')
  })

  it('should click on the Clock Manager button on the NavBar', () => {
    cy.get('nav').contains('Clock Manager').should('be.visible').wait(2000).click()

    cy.fixture('users/employee.json').then((userData) => {
      const expectedUrl = `/clockManager/${userData.username.replace(/ /g, '%20')}`
      cy.log('Expected URL:', expectedUrl)

      cy.url().should('include', expectedUrl)
    })
  })
})
