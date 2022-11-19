public class verifyRequestCheck {

    //version 1.0 - DM - unmanaged package consist of two calls:
    //Vonage Request a Verification API call
    //Vonage Verify Check API call 
        
    public static String vEndPoint = 'https://api.nexmo.com/verify/check/json';
    public static String apiEndPoint = 'https://api.nexmo.com/verify/json';
    public static final String headerType = 'application/x-www-form-urlencoded';
    
    public static String payload = '';
    public static String requestID;
    public static String pNum;
    public static String statusID;
    public static HttpResponse respond;
    
    public static Object sCache;
    public static String sCacheReqID;
    public static Object sCache3;
    public static String sCacheStatusID;
    public static String sCachePhone;
    public static String cachedVerify;
   
    @future(callout=true)
    public static void buildVerifyRequest(string phoneno){
         Cache.Org.put('local.verify1.verifyPhone', phoneno , 300);
                buildPayload(phoneno);
    } 

    public static HttpResponse makeRequest(){ 
        //system.debug(' payload in makeRequest '+ payload);
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();    
        request.setEndpoint(apiEndPoint);
        request.setMethod('POST');
        request.setHeader('Content-Type',headerType );
        request.setTimeout(120000);
        request.setBody(payload);          
        HttpResponse response = http.send(request);
            
        if (response.getStatusCode() == 200){
           System.debug('The status code returned what was expected:' +
           response.getStatusCode() + ' ' + response.getStatus());
                          
        }else {
           System.debug(response.getBody());  
         }

        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        system.debug(' <--map results--> '+ results);
        
        JSONParser parser = JSON.createParser(response.getBody());
        requestID ='';
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                (parser.getText() == 'request_id')) {
                    parser.nextToken();
                    requestID += parser.getText();
                }
        }
        
        sCache = requestID; 
        sCacheReqID = String.valueOf(sCache); 
        system.debug('what is the cached value '+ sCacheReqID);
        Cache.Org.put('local.verify1.verifyChk',sCacheReqID, 300);
   
        return response;
          } 
 
    //Build payload for the phone number (Request a Verification)
    //All credentials are stored on custom table NexmoCredential__c
    public static void buildPayload(String fromNo){
        String api_key='';
        String api_secret='';
        String brand='';
        String code='';
      
        
        pNum = fromNo;
        String Fno = pNum.substring(1,1);
        if (Fno == '1'){
            pNum = pNum.replaceAll('[^0-9]', ''); 
        }else{
            pNum = '1'+ pNum.replaceAll('[^0-9]', '');             
        }
        
        //Vonage credentials for the verify request call.
        for(NexmoCredential__c Ncreds : [SELECT api_key__c, api_secret__c, brand__c, code__c  FROM NexmoCredential__c]){
            api_key = Ncreds.api_key__c;
            api_secret = Ncreds.api_secret__c;
            brand = Ncreds.brand__c;
            code = Ncreds.code__c;
             
            payload = 'brand='+ EncodingUtil.urlEncode(brand,'UTF-8') +
                      '&code_length='+ EncodingUtil.urlEncode(code,'UTF-8')+
                      '&api_key='+ EncodingUtil.urlEncode(api_key,'UTF-8')+
                      '&api_secret='+ EncodingUtil.urlEncode(api_secret,'UTF-8')+
                      '&number='+ EncodingUtil.urlEncode(pNum,'UTF-8');
           
        }
        system.debug(' here is the payload '+ payload );  
        makeRequest();
              
    }
    
//This is the verifyCheck section of the code
//---This is the beginning of the pin code line ---//

    public static void buildPinPayload(String code){     
       
        String vpayload=''; 
        String v_api_key='';
        String v_api_secret='';
        String vpayloadcache = '';
           
        for(NexmoCredential__c Ncreds : [SELECT api_key__c, api_secret__c FROM NexmoCredential__c]){
                                         v_api_key = Ncreds.api_key__c;
                                         v_api_secret = Ncreds.api_secret__c;
            
            vpayload = '&api_key='+ EncodingUtil.urlEncode(v_api_key,'UTF-8')+
                       '&api_secret='+ EncodingUtil.urlEncode(v_api_secret,'UTF-8');                     
            
        }
      
        //placeholder for unit test for cacheVerify 
         if (Cache.Org.contains('verifyChk')) {
            cachedVerify = (String)Cache.Org.get('local.verify1.verifyChk');
            system.debug('whats in cachedVerify '+ cachedVerify);
       }
          
        if(cachedVerify == null){
             vpayloadcache = '&request_id='+ EncodingUtil.urlEncode('68a74792bd2f49b19e990a9b2a0774ff','UTF-8');
   
        }else{
             vpayloadcache = '&request_id='+ EncodingUtil.urlEncode(cachedVerify,'UTF-8');

        }
           vpayload =  vpayload + vpayloadcache +
                                  '&code='+ EncodingUtil.urlEncode(code,'UTF-8')+ 
                                  '&request_id='+ EncodingUtil.urlEncode('68a74792bd2f49b19e990a9b2a0774ff','UTF-8')+
                                  '&workflow_id='+ EncodingUtil.urlEncode('4','UTF-8');
             
         system.debug(' here is the vpayload '+ vpayload );  
         
        respond = Check(vpayload);
    } 
      
    
    public static HttpResponse Check(String vpl){ 
   
        Http http = new Http(); 
        HttpRequest  request = new HttpRequest();  
        request.setEndpoint(vEndPoint);
        request.setMethod('POST');  
        request.setHeader('Content-Type',headerType );
        request.setTimeout(10000);
        request.setBody(vpl);      
    
    HttpResponse response = http.send(request);
   
              
        if (response.getStatusCode() == 200){
           System.debug('The status code returned what was expected:' +
           response.getStatusCode() + ' ' + response.getStatus());
                          
        }else {
           System.debug(response.getBody());  
         }
       
       Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        system.debug(' <--map results--> '+ results);
      
        JSONParser parser = JSON.createParser(response.getBody());
        statusID ='';
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                (parser.getText() == 'status')) {
                    parser.nextToken();
                    statusID += parser.getText();
                }
        }
        //This is the local.Org.verify1 cache section. 
        sCache3 = statusID; 
        sCacheStatusID = String.valueOf(sCache3); 
        system.debug('what is the status '+ sCacheStatusID);
        Cache.Org.put('local.verify1.verifyChkStatus',sCacheStatusID, 300);
       
        if (Cache.Org.contains('verifyPhone')) {
            sCachePhone = (String)Cache.Org.get('local.verify1.verifyPhone');
          //  system.debug('whats in verifyPhone '+ sCachePhone);
        }
                  
       // system.debug('This is the cache lead update section. '+  sCachePhone);
       // this section feds into the VF page verifypin2 
        if(sCacheStatusID == '0'){
            try{
                 verify_Lead_ID__c vl = new verify_Lead_ID__c(Lead_Phone__c = sCachePhone);
                 upsert vl;
               }catch(exception e){
                System.debug('The following exception has occurred: ' + e.getMessage());
               }
         }  
   
       return response;
   }   
    
}