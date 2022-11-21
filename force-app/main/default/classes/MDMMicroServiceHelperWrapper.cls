/*********************************************************************************************************************

Component Name: MDMMicroServiceHelperWrapper

Objective: Wrapper class to hold required attributes to call MDM service apex classes

Created Date: 2022-11-16

Created By: Luke Vang

Test Class(es): MDMMicroServiceHelperWrapper_Test

Revision Log:

Developer Name: Luke Vang

**********************************************************************************************************************/
public class MDMMicroServiceHelperWrapper {
    @InvocableVariable
    public String serviceName;
    @InvocableVariable
    public String requestBody;
    @InvocableVariable
    public String recordId;
    
    public MDMMicroServiceHelperWrapper()
    {
    }
    
    public MDMMicroServiceHelperWrapper(String serviceName, String requestBody, String recordId)
    {
        this.serviceName = serviceName;
        this.requestBody = requestBody;
        this.recordId = recordId;
    }
}