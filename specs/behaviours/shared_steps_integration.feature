Feature: Shared Steps Integration
  This feature tests that shared steps work correctly with Cucumber
  
  # Exemption(e2e): shared steps reach a run only through step registration; alternative-proof: test:integration
  @e2e-exempt
  Scenario: Using shared authentication steps
    Given I am logged in as "test@example.com"
    When I navigate to my profile
    Then I should be authenticated
    
  # Exemption(e2e): shared steps reach a run only through step registration; alternative-proof: test:integration
  @e2e-exempt
  Scenario: Shared steps with different parameters
    Given I am logged in as "admin@example.com"
    And I have 5 items in my cart
    When I view my account details
    Then I should see "admin@example.com" as the current user
    And I should have 5 items total