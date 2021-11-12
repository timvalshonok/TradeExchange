@isTest
public with sharing class TradeHttpMock implements HttpCalloutMock {
    public HttpResponse respond(HttpRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"base": "EUR","date": "2021-11-11","rates": {"USD": 1.146243, "JPY": 130.690668}}');
        response.setStatusCode(200);
        return response;
    }
}
