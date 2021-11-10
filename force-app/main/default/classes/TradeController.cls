public inherited sharing class TradeController {

    @AuraEnabled(cacheable=true)
    public static List<Trade__c> getTrades(){
        List<Trade__c> result = [
            SELECT Sell_Currency__c, Sell_Amount__c, Buy_Currency__c, 
            Buy_Amount__c, Rate__c, Date_Booked__c, Trade_Id__c
            FROM Trade__c
            ORDER BY Date_Booked__c
            LIMIT 50
        ];
        return result;
    }

    public static Boolean isTradeIdExist(String tradeId){
        List<Trade__c> trades = [SELECT Trade_Id__c FROM Trade__c WHERE Trade_Id__c = :tradeId];
        return trades.size() != 0;
    }

    @AuraEnabled(cacheable=true)
    public static Decimal getRate(String sellCurrency, String buyCurrency){
        Decimal result;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String access_key = '8796047bee948b4c4088a81c5060a98a';
        String requestEndpoint = 'http://data.fixer.io/api/latest';

        requestEndpoint += '?access_key=' + access_key;
        requestEndpoint += '&base=EUR';
        requestEndpoint += '&symbols=' + sellCurrency + ',' + buyCurrency;
        System.Debug(requestEndpoint);
        request.setEndpoint(requestEndpoint);
        request.setMethod('GET');

        HttpResponse response = http.send(request);
        if(response.getStatusCode() == 200){
            JSONParser parser = JSON.createParser(response.getBody());
            result = TradeController.getRateFromJSON(parser, sellCurrency, buyCurrency);
        }
        return result;
    }

    private static Decimal getRateFromJSON(JSONParser parser, String sellCurrency, String buyCurrency){
        Decimal sellCurrencyRateFromJSON;
        Decimal buyCurrencyRateFromJSON;
        Datetime dateFromJSON;
        while(parser.nextToken() != null){
            System.Debug(parser.getText());
            if(parser.getText() == sellCurrency){
                parser.nextToken();
                sellCurrencyRateFromJSON = parser.getDecimalValue();
            }
            if(parser.getText() == buyCurrency){
                parser.nextToken();
                buyCurrencyRateFromJSON = parser.getDecimalValue();
            }
        }
        return buyCurrencyRateFromJSON / sellCurrencyRateFromJSON;
    }

    @AuraEnabled(cacheable=false)
    public static Trade__c addNewTrade(Trade__c newTrade){
        insert newTrade;
        System.debug('TRADE '+newTrade);
        return newTrade;
    }
}