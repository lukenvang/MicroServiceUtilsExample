
// IntegrationLogHelper utility class to create Integration Log return based on httprequest, http response, and record id
// recordId is assumed to be a salesforce record sobject type
public class IntegrationLogHelper {

    public static void createIntegrationLog(HttpRequest request, HttpResponse response, Id recordId)
    {
        if(request == null || response == null || recordId == null) return;
        String status = String.valueOf(response.getStatusCode()).startsWith('2') ? 'Success' : 'Fail';
        insert new Integration_Log__c(Request_Body__c = request?.getBody(), Response_Body__c = response?.getBody(), Record_Id__c = recordId, Org_Name__c = UserInfo.getOrganizationId(), Object_API_NAme__c = recordId.getSobjectType());
    }
}