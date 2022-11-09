//Invocable method used to call MDM services from flows
public class MDMMicroServiceHelperInvoke{
    @InvocableMethod(label='Perform Call Out to Microservices' description='Performs call out to microservices' callout=true)
    public static List<String> callMicroService(String serviceName, String requestBody, Id recordId)
    {
        List<String> result;
        String resp = MDMServiceHelper.callMicroService(serviceName, requestBody, recordId);
        if(resp != null){
            result = new List<String> { resp };
        }
        return result;
    }
}