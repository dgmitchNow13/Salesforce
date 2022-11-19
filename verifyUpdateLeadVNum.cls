public class verifyUpdateLeadVNum {
    
   @InvocableMethod (label='Update Verified Phone' description = 'Update all verified phone numbers' category= 'Lead')
    
    public static void getLeadVerifyPhone(List<String> phone ){ 
       List<verify_Lead_ID__c> vlead = [Select Lead_Phone__c From verify_Lead_ID__c where Lead_Phone__c = :phone];
       List<Lead> leaders = [select phone from lead where leadsource = 'Web2Lead' and Verified_Number__c = false];     
       
       for(verify_Lead_ID__c vl : vlead){
           for(Lead l : leaders){
               if(vl.Lead_Phone__c == l.phone){                
                   l.Verified_Number__c = true;          
                   }  
               }  
           }

       upsert leaders;
    }
}