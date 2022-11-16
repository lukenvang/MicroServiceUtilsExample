/*********************************************************************************************************************

Component Name: MDMMicroServiceHelperInvokeQueueable

Objective:Invokable class to call MDM services via queueable job. Use if more than 100 calls are needed.

Created Date: 2022-11-16

Created By: Luke Vang

Test Class(es): MDMMicroServiceHelperInvokeQueueable_Test

Revision Log:

Developer Name: Luke Vang

**********************************************************************************************************************/
public class MDMMicroServiceHelperInvokeQueueable {
    
    /**
    * @description calls MDM services as a queueable job
    * @author lvang@northteq.com | 11-16-2022 
    * @param wrappers 
    **/
    @InvocableMethod(label='Perform Call Out to MDM Microservices' description='Performs queueable call out to MDM microservices' callout=true)
    public static void callMicroServiceFuture(List<MDMMicroServiceHelperWrapper> wrappers)
    {
        MDMMicroServiceQueueable queueable = new MDMMicroServiceQueueable(wrappers);
        System.enqueueJob(queueable);
    }
}