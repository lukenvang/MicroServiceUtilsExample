/*********************************************************************************************************************

   Component Name: MDMServiceHelper

   Objective: Helper class for MDM services

   Created Date: 2022-11-16

   Created By: Luke Vang

   Test Class(es): MDMMicroServiceHelperInvoke_Test, MDMMicroServiceHelperInvokeFuture_Test, MDMMicroServiceHlperInvkeQueue_Test

   Revision Log:

   Developer Name: Luke Vang

 **********************************************************************************************************************/
public class MDMServiceHelper {

    static Integration_Setting__mdt integrationSetting;
    static Map<String, Integration_Setting__mdt> integrationSettingsMap;

    public class MDMServiceHelperException extends Exception {}

	
    /**
     * @description Called from MDMMicroServiceHelperInvokeQueueable. Calls APIs Calls APIs asynchronously as queueable job.
     * @author lvang@northteq.com | 11-16-2022
     * @param wrappers
     * @return List<String>
     **/

    public static void callMiroServiceQueueable(List<MDMMicroServiceHelperWrapper> wrappers)
    {
        MDMMicroServiceQueueable queueable = new MDMMicroServiceQueueable(wrappers);
        System.enqueueJob(queueable);
    }
    
    /**
     * @description Called from MDMMicroServiceHelperInvoke. Calls APIs synchronously and inserts logs at the end of all calls.
     * @author lvang@northteq.com | 11-16-2022
     * @param wrappers
     * @return List<String>
     **/
    public static List<String> callMicroService(List<MDMMicroServiceHelperWrapper> wrappers){
        HttpRest.insertLogsAtEnd = false;
        List<String> results = new List<String>();
        String resp;
        //if more than 100 just stop making the call, as you can only perform 100 API calls per transaction
        if(wrappers.size() > 100) {
            throw new MDMServiceHelperException('If more than 100 records need to be processed to call MDM service, use MDMMicroServiceHelperInvokeQueueable.');
        }
        for(MDMMicroServiceHelperWrapper wrapper : wrappers)
        {
            resp = callMicroService(wrapper.serviceName, wrapper.requestBody, wrapper.recordId);
            if(resp != null) {
                results.add(resp);
            }
        }
        IntegrationLogHelper.insertIntegrationLogs();
        return results;
    }

    /**
     * @description used to call MDM future method
     * @author lvang@northteq.com | 11-16-2022
     * @param wrappers
     **/
    public static void callMicroServiceFuture(List<MDMMicroServiceHelperWrapper> wrappers)
    {
        //if more than 50 just stop making the call, as you can only have 50 future calls per transaction
        if(wrappers.size() > 50) throw new MDMServiceHelperException('If more than 50 records need to be processed to call MDM service in future, use MDMMicroServiceHelperInvokeQueueable.');
        
        for(MDMMicroServiceHelperWrapper wrapper : wrappers)
        {
            callMicroServiceFuture(wrapper.serviceName, wrapper.requestBody, wrapper.recordId);
        }
    }

 
    /**
    * @description Use this to mdm services synchronously
    * @author lvang@northteq.com | 11-16-2022 
    * @param serviceName 
    * @param requestBody 
    * @param recordId 
    * @return String 
    **/
    public static String callMicroService(String serviceName, String requestBody, Id recordId){
        getIntegrationSettings(serviceName);
        requestBody = addSourceIdToRequest(requestBody);
        return makeHttpCallOut(serviceName, requestBody, recordId);
    }


    /**
    * @description Use this to call MDM services asynchronously
    * @author lvang@northteq.com | 11-16-2022 
    * @param serviceName 
    * @param requestBody 
    * @param recordId 
    **/
    @future(callout=true)
    public static void callMicroServiceFuture(String serviceName, String requestBody, Id recordId)
    {
        getIntegrationSettings(serviceName);
        requestBody = addSourceIdToRequest(requestBody);
        makeHttpCallOut(serviceName, requestBody, recordId);
    }

    /**
    * @description single function used to call HttpRest utility class
    * @author lvang@northteq.com | 11-16-2022 
    * @param serviceName 
    * @param requestBody 
    * @param recordId 
    * @return String 
    **/
    private static String makeHttpCallOut(String serviceName, String requestBody, Id recordId){
        Map<String, String> headerMap;
        if(!String.isBlank(integrationSetting.API_Key__c))
        {
            headerMap = new Map<String, String> { 'Authorization' => 'Bearer ' + integrationSetting.API_Key__c};
        }
        String response = HttpRest.doCallout(integrationSetting.End_Point__c, requestBody, 'POST', recordId, headerMap);
        return response;
    }

    /**
    * @description single function used to retrieve integration settings metadata records
    * @author lvang@northteq.com | 11-16-2022 
    * @param serviceName 
    **/
    private static void getIntegrationSettings(String serviceName){
        String environmentType = [SELECT isSandbox FROM Organization LIMIT 1].isSandbox ? 'Sandbox' : 'Production';

        if(integrationSettingsMap != null && integrationSettingsMap.get(serviceName) != null) {
            integrationSetting = integrationSettingsMap.get(serviceName);
        }
        List<Integration_Setting__mdt> intergrationSettings = [
            SELECT API_Key__c, End_Point__c, Source_Id__c
            FROM Integration_Setting__mdt
            WHERE End_Point__c != null AND Endpoint_Enabled__c =: true AND MasterLabel =: serviceName AND Environment__c =: environmentType
        ];
        if(intergrationSettings.isEmpty()) throw new MDMServiceHelperException('No enabled Integration Setting record found for service name : ' + serviceName);
        if(integrationSettingsMap == null) {
            integrationSettingsMap = new Map<String, Integration_Setting__mdt> ();
            integrationSettingsMap.put(serviceName, intergrationSettings[0]);
        }
        integrationSetting = intergrationSettings[0];
    }

    /**
    * @description function used to put source id into resource body
    * @author lvang@northteq.com | 11-16-2022 
    * @param requestBody 
    * @return String 
    **/
    private static String addSourceIdToRequest(String requestBody)
    {
        Map<String, Object> temp = (Map<String, Object>) JSON.deserializeUntyped(requestBody);
        temp.put('source', integrationSetting.Source_Id__c);
        return JSON.serialize(temp);
    }

}