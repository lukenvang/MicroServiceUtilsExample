/*********************************************************************************************************************

Component Name: MDMMicroServiceHelperInvoke

Objective: Invokable class to call MDM services synchronously. Less than 100 only.

Created Date: 2022-11-16

Created By: Luke Vang

Test Class(es): MDMMicroServiceHelperInvoke_Test

Revision Log:

Developer Name: Luke Vang

**********************************************************************************************************************/
public class MDMMicroServiceHelperInvoke{
    /**
    * @description Invocable function, used to call MDM microservices synchronously
    * @author lvang@northteq.com | 11-16-2022 
    * @param wrappers 
    * @return List<String> 
    **/
    @InvocableMethod(label='Perform Call Out to MDM Microservices' description='Performs call out to MDM microservices' callout=true)
    public static List<String> callMicroService(List<MDMMicroServiceHelperWrapper> wrappers)
    {
        return MDMServiceHelper.callMicroService(wrappers);
    }
}