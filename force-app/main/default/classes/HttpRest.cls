// HttpRest is a utility class used to make a external call out
public class HttpRest {

    public static String doCallout(String endpoint, String requestBody, Id recordId, Map<String, String> headerMap)
    {
        String resp;
        try{
            HttpRequest request = new HttpRequest();
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
                if((String.valueOf(response.getStatusCode()).startsWith('2') || !String.valueOf(response.getStatusCode()).startsWith('2'))&& response.getBody() != null) {
                    resp = response.getBody();
                }
            }
            IntegrationLogHelper.createIntegrationLog(request, response, recordId);
        }catch(Exception ex) {
            System.debug(ex.getMessage());
            System.debug(ex.getStackTraceString());
            throw ex;
        }
        return resp;
    }

}
