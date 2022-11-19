@isTest
public with sharing class verifyCheckOutTest {
 
    @isTest static void testVerifyCheck(){
          NexmoCredential__c n = new NexmoCredential__c();
          n.api_key__c = 'wsedrftgyh';
          n.api_secret__c = '123456789';
          insert n;
        
          Lead l = new Lead();
          l.LastName = 'Doe';
          l.Company = 'Acompany';
          l.Phone = '4155551212';  
          l.pin__c = '1234';
          insert l;
     
        //  String payload ='api_key=wsedrftgyh&api_secret=123456789&code=1234&request_id=68a74792bd2f49b19e990a9b2a0774ff&workflow_id=4';      
    	  verifyRequestCheck dgm = new verifyRequestCheck();
          
        String body ='{"currency":"EUR","estimated_price_messages_sent" :"0.00620000","event_id":"1300000118B9848F","price":"0.05000000", "request_id":"cc467e993b1';      
        HttpResponse responseFriends = new HttpResponse();
        responseFriends.setStatusCode(200);
        responseFriends.setStatus('OK');
        responseFriends.setBody(body);
        
        Test.startTest();
          Test.setMock(HttpCalloutMock.class, new verifyCheckMock(responseFriends));
          verifyRequestCheck.buildPinPayload('1234');
        Test.stopTest();
        
        //System.Assert(dgm.buildPinPayload(code) != null && !fdc.friends.isEmpty());
 /**       
   Test.startTest();     
        donald.buildPinPayload(l.pin__c);
  
    // Set mock callout class 
  Test.setMock(HttpCalloutMock.class, new verifyCheckMock());
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock.  
        HttpResponse response = donald.Check(payload);   
  Test.stopTest(); 
        // Verify that the response received contains fake values
        String contentType = response.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = response.getBody();
        System.debug(response.getBody());
        String expectedValue = '{"currency":"EUR","estimated_price_messages_sent" :"0.00620000","event_id":"1300000118B9848F","price":"0.05000000", "request_id":"cc467e993b1f480187485db64eeae005","status":"0"}';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, response.getStatusCode());
 **/
    }    
    
}