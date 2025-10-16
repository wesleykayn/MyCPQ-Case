/****************************************************************************************
Name            : AccountCancelReplaceControllerTest
Revision Log    : 8/11/2020 Bryan
Updated By      : Captain (GPT-5)
Use             : Cancel and replace test class | Fixed Contract_Status__c usage and variable references
*****************************************************************************************/
@IsTest
private class AccountCancelReplaceControllerTest {

    private static final String ADMIN_USER_EMAIL = 'AccountCancelReplaceControllerTest@cpqcr.com';
    
    // Create setup data
    @TestSetup
    private static void makeData() {
        TestUserFactory.createUserAdmin(ADMIN_USER_EMAIL);
    }

    private static User getAdminUser() {
        return [SELECT Id FROM User WHERE Email = :ADMIN_USER_EMAIL LIMIT 1];
    }

    // Test 1: No Contracts
    @IsTest
    static void getContracts_noContracts_emptyList() {
        User adminUser = getAdminUser();

        System.runAs(adminUser) {
            Account account = TestDataFactory.generateAccount('TestAccount');
            insert account;

            Test.startTest();
            List<ContractMsg> contracts = AccountCancelReplaceController.getContracts(
                new List<String>{ account.Id }, 'All'
            );
            Test.stopTest();

            System.assertEquals(0, contracts.size(), 'We should not have any contracts for this account');
        }
    }

    // Test 2: One active contract should return one record
    @IsTest
    static void getContracts_OneContract_ListOfOne() {
        User adminUser = getAdminUser();

        System.runAs(adminUser) {
            //Create test Account
            Account account = TestDataFactory.generateAccount('TestAccount');
            insert account;

            //Activate standard Pricebook
            Pricebook2 standardPricebook = new Pricebook2(
                Id = Test.getStandardPricebookId(),
                IsActive = true
            );
            update standardPricebook;

            //Create Product
            Product2 product = new Product2(
                Name = 'iPhone X',
                ProductCode = 'TP-001',
                Family = 'Mobile'
            );
            insert product;

            //Create PricebookEntry
            PricebookEntry pbe = new PricebookEntry(
                Pricebook2Id = standardPricebook.Id,
                Product2Id = product.Id,
                UnitPrice = 1020,
                IsActive = true
            );
            insert pbe;

            //Create Opportunity
            Opportunity opp = new Opportunity(
                Name = 'Test Opportunity',
                Pricebook2 = standardPricebook,
                CloseDate = Date.today().addDays(10),
                AccountId = account.Id,
                StageName = 'Create',
                Probability = 100
            );
            insert opp;

            //Add OpportunityLineItem
            OpportunityLineItem oli = new OpportunityLineItem(
                OpportunityId = opp.Id,
                PricebookEntryId = pbe.Id,
                Quantity = 2,
                TotalPrice = 2040
            );
            insert oli;

            //Create Quote
            SBQQ__Quote__c quote = new SBQQ__Quote__c(
                SBQQ__Account__c = account.Id,
                SBQQ__Opportunity2__c = opp.Id,
                SBQQ__PriceBook__c = standardPricebook.Id,
                SBQQ__Primary__c = true,
                SBQQ__StartDate__c = Date.today(),
                SBQQ__SubscriptionTerm__c = 36
            );
            insert quote;

            //Mark Opp as contracted
            opp.SBQQ__Contracted__c = true;
            update opp;

            //Create Contract with valid EndDate and Contract_Status__c = Active
            Contract contract = new Contract(
                AccountId = account.Id,
                SBQQ__Opportunity__c = opp.Id,
                SBQQ__Quote__c = quote.Id,
                StartDate = Date.today().addMonths(-1), // in the past
                EndDate = Date.today().addMonths(6),    // future date → should pass EndDate > TODAY
                ContractTerm = 6,
                Contract_Status__c = 'Active'
            );
            insert contract;

            Test.startTest();
            //Call method under test
            List<ContractMsg> contracts = AccountCancelReplaceController.getContracts(
                new List<String>{ account.Id }, '5'
            );
            Test.stopTest();

            //Assert results
            System.assertEquals(1, contracts.size(), 
                'There should be one active contract for this account');
            System.assertEquals(contract.Id, contracts[0].Id,
                'Returned contract should match the created contract');
        }
    }


    // Test 3: Amend Contract Flow
    @IsTest
    static void amendContracts_OneContract_newQuote() {
        User adminUser = getAdminUser();

        System.runAs(adminUser) {
            Account account = TestDataFactory.generateAccount('TestAccount');
            insert account;

            Pricebook2 standardPricebook = new Pricebook2(
                Id = Test.getStandardPricebookId(), IsActive = true
            );
            update standardPricebook;

            Product2 pro = new Product2(Name = 'iPhone X', ProductCode = 'TP-002', Family = 'Mobile');
            insert pro;

            PricebookEntry pbe = new PricebookEntry(
                Pricebook2Id = standardPricebook.Id,
                Product2Id = pro.Id,
                UnitPrice = 1020,
                IsActive = true
            );
            insert pbe;

            Opportunity opp = new Opportunity(
                Name = 'Amend Opp',
                PriceBook2 = standardPricebook,
                CloseDate = Date.newInstance(2025, 10, 17),
                AccountId = account.Id,
                StageName = 'Create',
                Probability = 100
            );
            insert opp;

            OpportunityLineItem oli = new OpportunityLineItem(
                OpportunityID = opp.Id,
                PriceBookEntryID = pbe.Id,
                Quantity = 3,
                TotalPrice = 3060
            );
            insert oli;

            SBQQ__Quote__c quote = new SBQQ__Quote__c(
                SBQQ__Account__c = account.Id,
                SBQQ__Opportunity2__c = opp.Id,
                SBQQ__PriceBook__c = standardPricebook.Id,
                SBQQ__Primary__c = true,
                SBQQ__StartDate__c = Date.newInstance(2025, 10, 17),
                SBQQ__SubscriptionTerm__c = 24
            );
            insert quote;

            opp.SBQQ__Contracted__c = true;
            update opp;

            Contract contract = new Contract(
                AccountId = account.Id,
                SBQQ__Opportunity__c = opp.Id,
                SBQQ__Quote__c = quote.Id,
                StartDate = Date.today(),
                Contract_Status__c = 'Active'
            );
            insert contract;

            Test.startTest();
            AmendContractsMsg amendContractMsg = new AmendContractsMsg();
            amendContractMsg.contractIds = new List<String>{ contract.Id };
            amendContractMsg.startDate = String.valueOf(Date.newInstance(2025, 10, 17));
            amendContractMsg.opportunityStage = 'Create';
            amendContractMsg.opportunityName = 'Amend Opp New';
            amendContractMsg.accountId = account.Id;
            amendContractMsg.termLength = 36;

            AmendContractJobMsg jobmsg = AccountCancelReplaceController.amendContracts(amendContractMsg);
            List<String> jobIds = new List<String>();

            for (AmendContractJobMsg.JobStatus job : jobmsg.jobs) {
                jobIds.add(job.jobId);
            }

            List<AmendContractJobStatusMsg> jobStatuses = AccountCancelReplaceController.getJobStatus(jobIds);
            Test.stopTest();

            System.assert(jobStatuses.size() > 0, 'Expected job statuses to be returned');
        }
    }


    @IsTest
    private static void getOpportunityStageValues_valuesReturned() {
        Test.startTest();
        List<PicklistMsg> picklistValues = AccountCancelReplaceController.getOpportunityStageValues();
        Test.stopTest();
        System.assert(picklistValues.size() > 0, 'Expected picklist values to be returned');
    }

    @IsTest
    private static void getAccounts_231Records_231Returned() {
        User adminUser = getAdminUser();

        System.runAs(adminUser) {
            Account parentAccount = TestDataFactory.generateAccount('parentAccount');
            insert parentAccount;

            List<Account> level2Accounts = TestDataFactory.inflateChildAccountsWithNamePrefix(
                new List<Account>{ parentAccount }, 'level2 ', 5
            );
            insert level2Accounts;

            List<Account> level3Accounts = TestDataFactory.inflateChildAccountsWithNamePrefix(level2Accounts, 'level3 ', 3);
            insert level3Accounts;

            List<Account> level4Accounts = TestDataFactory.inflateChildAccountsWithNamePrefix(level3Accounts, 'level4 ', 2);
            insert level4Accounts;

            List<Account> level5Accounts = TestDataFactory.inflateChildAccountsWithNamePrefix(level4Accounts, 'level5 ', 2);
            insert level5Accounts;

            List<Account> level6Accounts = TestDataFactory.inflateChildAccountsWithNamePrefix(level5Accounts, 'level6 ', 2);
            insert level6Accounts;

            Test.startTest();
            List<String> accountIds = AccountCancelReplaceController.getAccounts(level4Accounts[3].Id);
            Test.stopTest();

            System.assertEquals(231, accountIds.size(), 'Expected 231 accounts returned');
        }
    }
}
