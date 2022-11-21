/*********************************************************************************************************************

Component Name: IntegrationLogHelper

Objective: Single entry point to to create Integration Logs for MDM services

Created Date: 2022-11-16

Created By: Luke Vang

Test Class(es): IntegrationLogHelper_Test 100%

Revision Log:

Developer Name: Luke Vang

**********************************************************************************************************************/
public class IntegrationLogHelper {

    static List<Integration_Log__c> integrationLogs;
    
    /**
    * @description Adds an integration log to collection
    * @author lvang@northteq.com | 11-16-2022 
    * @param request 
    * @param response 
    * @param recordId 
    **/
    public static void addIntegrationLog(HttpRequest request, HttpResponse response, Id recordId)
    {
        if(request == null || response == null || recordId == null) return;
        if(integrationLogs == null){
            integrationLogs = new List<Integration_Log__c>(); 
        }
        String status = String.valueOf(response.getStatusCode()).startsWith('2') ? 'Success' : 'Fail';
        integrationLogs.add(new Integration_Log__c(Status__c = status, Request_Body__c = request?.getBody(), Response_Body__c = response?.getBody(), Record_Id__c = recordId, Org_Name__c = UserInfo.getOrganizationId(), Object_API_NAme__c = String.valueOf(recordId.getSobjectType())));
    }
    
    /**
    * @description adds an integration log that captures exception details
    * @author lvang@northteq.com | 11-16-2022 
    * @param ex 
    * @param recordId 
    **/
    public static void addIntegrationLogException(Exception ex, Id recordId)
    {
        if(ex == null || recordId == null) return;
        if(integrationLogs == null){
            integrationLogs = new List<Integration_Log__c>(); 
        }
        System.debug(ex.getMessage());
        System.debug(ex.getStackTraceString());
        String stackTrace = 'Exception message --->>:: ' + ex.getMessage() + ' At Stack Trace :: ' + ex.getStackTraceString();
        integrationLogs.add(new Integration_Log__c(Stack_Trace__c = stackTrace, Record_Id__c = recordId, Org_Name__c = UserInfo.getOrganizationId(), Object_API_NAme__c = String.valueOf(recordId.getSobjectType())));
    }
    
    /**
    * @description inserts intergration logs from collection
    * @author lvang@northteq.com | 11-16-2022 
    **/
    public static void insertIntegrationLogs()
    {
        if(integrationLogs != null && !integrationLogs.isEmpty()){
            insert integrationLogs;
        }
    }
}