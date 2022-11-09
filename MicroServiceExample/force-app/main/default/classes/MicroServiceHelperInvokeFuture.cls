//Invocable method used to call MDM services from flows
public class MDMMicroServiceHelperInvokeFuture {
    @InvocableMethod(label='Perform Call Out to Microservices' description='Performs future call out to microservices' callout=true)
    public static void callMicroServiceFuture(String serviceName, String requestBody, Id recordId)
    {
        MDMServiceHelper.callMicroServiceFuture(serviceName, requestBody, recordId);
    }
}