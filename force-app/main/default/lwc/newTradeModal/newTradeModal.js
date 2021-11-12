import { LightningElement } from 'lwc';
import getRate from '@salesforce/apex/TradeController.getRate';
import addNewTrade from '@salesforce/apex/TradeController.addNewTrade';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const currencies = [
    { label: 'USD', value: 'USD' },
    { label: 'JPY', value: 'JPY' },
    { label: 'AUD', value: 'AUD' },
    { label: 'CAD', value: 'CAD' },
];

export default class NewTradeModal extends LightningElement {
    currencies = currencies;
    sellCurrency;
    buyCurrency;
    sellAmount;
    buyAmount;
    rate;
    dateBooked;

    handleSellCurrencyChange(event) {
        this.sellCurrency = event.target.value;
    }

    handleBuyCurrencyChange(event) {
        this.buyCurrency = event.target.value;
        this.calculateRate();
    }

    handleSellAmountChange(event) {
        this.sellAmount = event.target.value;
        this.calculateRate();
    }

    closeModal() {
        this.dispatchEvent(new CustomEvent('close'));
    }

    calculateRate() {
        if(this.sellCurrency == this.buyCurrency){
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'You selected the same currencies!',
                    variant: 'error'
                })
            );
            return;
        }
        getRate({sellCurrency: this.sellCurrency, buyCurrency: this.buyCurrency})
        .then((response) => {
            this.rate = parseFloat(response).toFixed(2);
            this.buyAmount = (this.sellAmount * this.rate).toFixed(2);
        })
        .catch((error) => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Something went wrong',
                    variant: 'error'
                })
            );
        })
    }

    createTrade() {
        let trade = {
            Sell_Currency__c : this.sellCurrency,
            Sell_Amount__c : this.sellAmount,
            Buy_Currency__c : this.buyCurrency,
            Buy_Amount__c : this.buyAmount,
            Rate__c : this.rate
        };
        if(!this.sellAmount || !this.buyCurrency || !this.sellCurrency || !this.rate || !this.buyAmount) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Please fill all required fields',
                    variant: 'error'
                })
            );
            return;
        }
        addNewTrade({newTrade: trade})
        .then(() => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Trade created',
                    variant: 'success'
                })
            );
            this.dispatchEvent(new CustomEvent("rerendertrades"));
            this.closeModal();
        })
        .catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error creating trade',
                    message: error.body.message,
                    variant: 'error',
                })
            );
        })        
    }
}
