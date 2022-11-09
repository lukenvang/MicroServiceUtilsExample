//MicroServiceHelper
//Utility to call MDM services.
public class MDMServiceHelper {

    public static MicroServiceIntegrationSettings__mdt msiSettings;

    public class MDMServiceHelperException extends Exception {}

    //use to call MDM service synchronously
    public static String callMicroService(String serviceName, String requestBody, Id recordId){
        requestBody = addSourceIdToRequest(requestBody);
        String response = makeHttpCallOut(serviceName, requestBody, recordId);
        return response;
    }


    //use to call MDM service asynchronously
    @future
    public static void callMicroServiceFuture(String serviceName, String requestBody, Id recordId)
    {
        requestBody = addSourceIdToRequest(requestBody);
        makeHttpCallOut(serviceName, requestBody, recordId);
    }

    private static String makeHttpCallOut(String serviceName, String requestBody, Id recordId){
        msiSettings = getMicroServiceIntegrationSettings(serviceName);
        Map<String, String> headerMap;
        if(!String.isBlank(msiSettings.API_Key__c))
        {
            headerMap = new Map<String, String> { 'Authorization' => 'Bearer ' + msiSettings.API_Key__c};
        }
        String response = HttpRest.doCallout(msiSettings.Microservice_Endpoint__c, requestBody, msiSettings.Method__c, recordId, headerMap);
        return response;
    }

    private static MicroServiceIntegrationSettings__mdt  getMicroServiceIntegrationSettings(String serviceName){
        String environmentType = [SELECT isSandbox FROM Organization LIMIT 1].isSandbox ? 'Sandbox' : 'Production';
        List<MicroServiceIntegrationSettings__mdt> msiSettings = [SELECT API_Key__c, Microservice_Endpoint__c, Source_Id__c, Method__c FROM MicroServiceIntegrationSettings__mdt WHERE Microservice_Endpoint__c != null && Microservice_Endpoint_Enabled__c =: true AND MasterLabel =: serviceName AND Environment_Type__c =: environmentType];
        if(msiSettings.isEmpty()) throw new MDMServiceHelperException('No enabled Microservice Integration Setting record found for service name : ' + serviceName);
        return msiSettings[0];
    }

    private static String addSourceIdToRequest(String requestBody)
    {
        Map<String, Object> temp = (Map<String, Object>) JSON.deserializeUntyped(requestBody);
        temp.put('source', msiSettings.Source_Id__c);
        return JSON.serialize(temp);
    }

}
