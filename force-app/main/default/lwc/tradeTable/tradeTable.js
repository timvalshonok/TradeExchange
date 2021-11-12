import { LightningElement, wire } from 'lwc';
import getTrades from '@salesforce/apex/TradeController.getTrades';
import { refreshApex } from '@salesforce/apex';

export default class TradeTable extends LightningElement {
    tradesResponse;
    listTrades;
    newTradeModal;

    @wire(getTrades)
    wiredTrades(result) {
        this.tradesResponse = result;
        if(result.data){
            this.listTrades = result.data;
        } else if(result.error){
            this.listTrades = result.error;
        }
    }

    showNewTradeModal(event) {
        this.newTradeModal = true;
    }

    hideNewTradeModal(event) {
        this.newTradeModal = false;
    }

    rerenderTrades(event) {
        refreshApex(this.tradesResponse);
    }
}
