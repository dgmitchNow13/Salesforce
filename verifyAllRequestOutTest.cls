@isTest 
public class verifyAllRequestOutTest {
  
 /** working correctly **/
     
    @isTest (SeeAllData=false) static void testVerifyRequest(){  
            NexmoCredential__c n = new NexmoCredential__c();
            n.api_key__c = 'zsxdcfv';
            n.api_secret__c = '123456789';
            n.brand__c ='Vonage';
            n.code__c = '4';
            insert n;       
        
            Lead l = new Lead();
            l.LastName = 'Doe';
            l.Company = 'Acompany';
            l.Phone = '4155551212';  
            insert l;
        
           // verifyAll5 x = new verifyAll5();
           verifyRequestCheck x = new verifyRequestCheck();
           
            // Set mock callout class 
        Test.startTest();
            verifyRequestCheck.buildVerifyRequest(l.Phone); 
            Test.setMock(HttpCalloutMock.class, new verifyCOvReqMock()); 
            // This causes a fake response to be sent
            // from the class that implements HttpCalloutMock. 
            HttpResponse response = verifyRequestCheck.makeRequest() ;
         Test.stopTest();
            // Verify that the response received contains fake values
            String contentType = response.getHeader('Content-Type');
            System.assert(contentType == 'application/json');
            String actualValue = response.getBody();
            System.debug(response.getBody());
            String expectedValue = '{"request_id":"cc467e993b1f48018748","status":"0"}';
            System.assertEquals(actualValue, expectedValue);
            System.assertEquals(200, response.getStatusCode());
    }

 
}