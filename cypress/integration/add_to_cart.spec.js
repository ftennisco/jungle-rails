describe("Adding products to the cart on the home page", () => {
  beforeEach(() => {
    // Visit the home page before each test
    cy.visit('http://localhost:3000');
  });

  it('allows a user to add a product to the cart', () => {
    // Adjust the selector based on your actual application
    cy.get(':nth-child(1) > div > .button_to > .btn')
      .click({ force: true });
    // Here you need to update the selector to whatever shows the cart count in your app
    // You're looking for something akin to a shopping cart icon or label that displays a number
    cy.get('[href="/cart"]').should('contain', '1');
  });
});