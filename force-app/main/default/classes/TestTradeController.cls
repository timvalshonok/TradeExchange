@isTest
public class TestTradeController {
    @TestSetup static void setup(){
        List<Trade__c> trades = new List<Trade__c>();
        Trade__c trade = new Trade__c(Rate__c = 1.00);
        trades.add(trade);
        insert trades;
    }

    @isTest public static void testGetTrades(){
        Test.startTest();
        List<Trade__c> actual = TradeController.getTrades();
        Test.stopTest();

        List<Trade__c> expected = [SELECT Trade_Id__c, Rate__c FROM Trade__c];
        System.assertEquals(expected[0].Rate__c, actual[0].Rate__c, 'Should be one Trade with "Rate = 1.00"');
    }

    @isTest public static void testGetRate(){
        String sellCurrency = 'USD';
        String buyCurrency = 'JPY';

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new TradeHttpMock());
        Decimal actual = TradeController.getRate(sellCurrency, buyCurrency);
        Test.stopTest();

        Decimal expected = 114.016546229726157542510619475975;
        System.assertEquals(actual, expected, 'Should be Rate with value = "114.016546229726157542510619475975"');
    }

    @isTest public static void testAddNewTrade(){
        Decimal rate = 2.00;
        Trade__c trade = new Trade__c(Rate__c = rate);

        Test.startTest();
        TradeController.addNewTrade(trade);
        Test.stopTest();

        Trade__c expected = [SELECT Rate__c FROM Trade__c WHERE Rate__c = :rate];
        System.assertEquals(expected, trade, 'Should be added new Trade with Rate__c = 2.00');
    }
}
