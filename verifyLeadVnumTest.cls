@isTest
public class verifyLeadVnumTest {
    
    @isTest static void verifyLeadVnumTest(){
        Test.startTest(); 
     
        verify_Lead_ID__c v = new verify_Lead_ID__c(Lead_Phone__c = '4155551212');
        insert v;
            
        List<String> p = new List<String>();
        p.add('4155551212');
           verifyUpdateLeadVNum.getLeadVerifyPhone(p);        
        Test.stopTest();
               
        System.assertEquals('4155551212', v.Lead_Phone__c);
         
   }
}