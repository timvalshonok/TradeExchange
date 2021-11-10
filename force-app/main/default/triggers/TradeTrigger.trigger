trigger TradeTrigger on Trade__c (before insert) {
    if(Trigger.isInsert){
        for(Trade__c trade : Trigger.new){
            while(true){
                String generatedId = IdGenerator.generateRandomAlphanumericId();
                if(TradeController.isTradeIdExist(generatedId)){
                    continue;
                } else {
                    trade.Trade_Id__c = generatedId;
                    trade.Date_Booked__c = Datetime.now().format('dd/MM/yyyy HH:mm');
                    break;
                }
            }
        }
    }
}