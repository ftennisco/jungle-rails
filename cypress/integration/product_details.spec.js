describe("home_page feature", () => {
  beforeEach(() => {
    // Visit the home page before each test
    cy.visit('http://localhost:3000');
  });

  it("There are products on the page", () => {
    cy.get(".products article").should("be.visible");
  });

  it("There are 12 products on the page", () => {
    cy.get(".products article").should("have.length", 12);
  });

  it("Click on a product partial to navigate to product detail page", () => {
    cy.get(".products article:first-child a").click();
    cy.url().should("include", "http://localhost:3000/products/12");
    cy.get(".product-detail").should("be.visible");
  });
});
