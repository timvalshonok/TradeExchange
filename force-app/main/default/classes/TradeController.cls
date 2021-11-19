public inherited sharing class TradeController {

    @AuraEnabled(cacheable=true)
    public static List<Trade__c> getTrades() {
        List<Trade__c> trades = [
            SELECT Sell_Currency__c, Sell_Amount__c, Buy_Currency__c, 
                Buy_Amount__c, Rate__c, Date_Booked__c, Trade_Id__c
            FROM Trade__c
            ORDER BY Date_Booked__c
            LIMIT 50
        ];
        return trades;
    }

    @AuraEnabled(cacheable=true)
    public static Decimal getRate(String sellCurrency, String buyCurrency) {
        Decimal rate;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String access_key = '1b08ae714e18312b49506f257e20ae0f';
        String requestEndpoint = 'http://data.fixer.io/api/latest';

        requestEndpoint += '?access_key=' + access_key;
        requestEndpoint += '&base=EUR';
        requestEndpoint += '&symbols=' + sellCurrency + ',' + buyCurrency;
        request.setEndpoint(requestEndpoint);
        request.setMethod('GET');

        HttpResponse response = http.send(request);
        if(response.getStatusCode() == 200) {
            JSONParser parser = JSON.createParser(response.getBody());
            rate = TradeController.getRateFromJSON(parser, sellCurrency, buyCurrency);
        }
        return rate;
    }

    private static Decimal getRateFromJSON(JSONParser parser, String sellCurrency, String buyCurrency) {
        Decimal sellCurrencyRateFromJSON;
        Decimal buyCurrencyRateFromJSON;
        while(parser.nextToken() != null) {
            if(parser.getText() == sellCurrency) {
                parser.nextToken();
                sellCurrencyRateFromJSON = parser.getDecimalValue();
            }
            if(parser.getText() == buyCurrency) {
                parser.nextToken();
                buyCurrencyRateFromJSON = parser.getDecimalValue();
            }
        }
        return buyCurrencyRateFromJSON / sellCurrencyRateFromJSON;
    }

    @AuraEnabled(cacheable=false)
    public static Trade__c addNewTrade(Trade__c newTrade) {
        insert newTrade;
        return newTrade;
    }
}
