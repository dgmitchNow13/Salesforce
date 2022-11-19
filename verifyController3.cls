public class verifyController3 {
    String pin;
    String results;
    String results2;
    String text1;
    String text2;
    String text3;
    public static String cachedVerifyStatus;
    
    public String gettext1(){
    return text1;    
    }
    
    public String gettext2(){
        return text2;   
    } 
    
    public String gettext3(){
        return text3;   
    } 
     
    public String getpin(){
    return pin;    
    }    
    
    public String getresults(){
     return results;   
    }  
    
    public String getresults2(){
     return results2;   
    }
     
    public void setpin(String s){
     pin = s;
    }
    
    public pageReference save(){
         
        verifyRequestCheck.buildPinPayload(pin);
       system.debug('your in the controller');
     
       if (Cache.Org.contains('verifyChkStatus')) {
          cachedVerifyStatus = (String)Cache.Org.get('verifyChkStatus');
       system.debug('whats in controller cachedVerify '+ cachedVerifyStatus);
        }    
           
    results = cachedVerifyStatus;   
    system.debug(' Give me the results for validation '+ results);
    if(results == '0'){ results2 ='Validation Complete';}else{ results2 = 'Validation failed. Please contact Sales Associate.';}       
        
    return null;   
    }     

}