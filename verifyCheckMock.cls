@isTest
public class verifyCheckMock implements HttpCalloutMock{
        // Implement this interface method
    private HttpResponse response;
    private Integer code;
    private String status;
    private Map<String, String> headers;
 
    public verifyCheckMock(HttpResponse response) {
        this.response = response;
    } 
    
    public verifyCheckMock(Integer code, String status, String body, Map<String, String> headers) {
        this.code = code;
        this.status = status;
        this.headers = headers;  
    }
           
    public HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setBody('{"currency":"EUR","estimated_price_messages_sent" :"0.00620000","event_id":"1300000118B9848F","price":"0.05000000", "request_id":"cc467e993b1f480187485db64eeae005","status":"0"}');
        response.setStatusCode(200);
        response.setHeader('Content-Type',  'application/json');
        if (headers != null) {
                for (String key : headers.keySet()) {
                    response.setHeader(key, headers.get(key));
                }
            }
        
        return response; 
    }

}