/*********************************************************************************************************************

Component Name: HttpRest

Objective: Single entry point to perform calls out for MDM service

Created Date: 2022-11-16

Created By: Luke Vang

Test Class(es): HttpRest_Test

Revision Log:

Developer Name: Luke Vang

**********************************************************************************************************************/
public class HttpRest {
    
    //use this flag if multiple API calls are being made in a single transaction
    //setting this to false will not insert logs
    //you must call IntegrationLogHelper.insertIntegrationLogs() to insert logs if this flag is false
    public static Boolean insertLogsAtEnd = true;
    
    /**
    * @description Utility function used to make callouts to MDM service
    * @author lvang@northteq.com | 11-16-2022 
    * @param endpoint 
    * @param requestBody 
    * @param method 
    * @param recordId 
    * @param headerMap 
    * @return String 
    **/
    public static String doCallout(String endpoint, String requestBody, String method, Id recordId, Map<String, String> headerMap)
    {
        String resp;
        try{
            HttpRequest request = new HttpRequest();
            request.setMethod(method);
            if(!String.isBlank(requestBody)) request.setBody(requestBody);
            if(headerMap != null && !headerMap.isEmpty())
            {
                for(String key : headerMap.keySet())
                {
                    request.setHeader(key, headerMap.get(key));
                }
            }
            request.setTimeout(120000); //set timeout to maximum
            Http http = new Http();
            HttpResponse response = http.send(request);
            if(response != null) {
                if((String.valueOf(response.getStatusCode()).startsWith('2') || !String.valueOf(response.getStatusCode()).startsWith('2')) && response.getBody() != null) {
                    resp = response.getBody();
                }
            }
            IntegrationLogHelper.addIntegrationLog(request, response, recordId);
        }catch(Exception ex) {
            IntegrationLogHelper.addIntegrationLogException(ex, recordId);
        }finally{
            if(insertLogsAtEnd){
                IntegrationLogHelper.insertIntegrationLogs();
            }
        }
        return resp;
    }
}