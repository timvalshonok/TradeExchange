@isTest
private class TradeTriggerTest {
    @isTest static void generateIdTest(){
        Trade__c trade = new Trade__c(Rate__c = 1.00);

        Test.startTest();
        insert trade;
        Test.stopTest();

        List<Trade__c> actual = [SELECT Trade_Id__c FROM Trade__c WHERE Rate__c = :trade.Rate__c LIMIT 1];
        System.assert(actual[0].Trade_Id__c.contains('TR'), 'Should generate and add Id to the Trade');
    }
}
