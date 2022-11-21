/*********************************************************************************************************************

Component Name: MDMMicroServiceHelperInvokeFuture

Objective:Invokable class to call MDM services via future method. Use if less than 100 calls are needed.

Created Date: 2022-11-16

Created By: Luke Vang

Test Class(es): MDMMicroServiceHelperInvokeFuture_Test

Revision Log:

Developer Name: Luke Vang

**********************************************************************************************************************/
public class MDMMicroServiceHelperInvokeFuture {

    /**
    * @description Used to call MDM services using future method
    * @author lvang@northteq.com | 11-16-2022 
    * @param wrappers 
    **/
    @InvocableMethod(label='Perform Call Out to MDM Microservices' description='Performs future call out to MDM microservices' callout=true)
    public static void callMicroServiceFuture(List<MDMMicroServiceHelperWrapper> wrappers)
    {
        MDMServiceHelper.callMicroServiceFuture(wrappers);
        
    }
}