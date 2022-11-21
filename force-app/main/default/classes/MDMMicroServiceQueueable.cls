/*********************************************************************************************************************

Component Name: MDMMicroServiceQueueable

Objective:Queueable class to call MDM services. Only process 100 at a time. Create a batch class if more is needed.

Created Date: 2022-11-16

Created By: Luke Vang

Test Class(es): MDMMicroServiceHlperInvkeQueue_Test

Revision Log:

Developer Name: Luke Vang

**********************************************************************************************************************/
public class MDMMicroServiceQueueable implements Queueable, Database.AllowsCallouts {
    
    List<MDMMicroServiceHelperWrapper> wrappers;
    Map<String, MDMMicroServiceHelperWrapper> wrapperMap;
    
    public MDMMicroServiceQueueable(List<MDMMicroServiceHelperWrapper> wrappers){
        this.wrappers = wrappers;
    }
    
    public MDMMicroServiceQueueable(Map<String, MDMMicroServiceHelperWrapper> wrapperMap)
    {
        this.wrapperMap = wrapperMap;
    }
    
    public void execute(QueueableContext context) {
        Map<String, MDMMicroServiceHelperWrapper> temp = new Map<String, MDMMicroServiceHelperWrapper>();
        if(wrappers.isEmpty())  return;
           
        if(wrapperMap == null)
        {
            wrapperMap = new Map<String, MDMMicroServiceHelperWrapper>();
            for(MDMMicroServiceHelperWrapper wrapper : wrappers){
                wrapperMap.put(wrapper.recordId, wrapper);
            }
        }
        temp = wrapperMap;
        HttpRest.insertLogsAtEnd = false;
        
        Integer count = 0;
        for(MDMMicroServiceHelperWrapper wrapper : wrappers){
            if(count > 99) break;

            MDMServiceHelper.callMicroService(wrapper.serviceName, wrapper.requestBody, wrapper.recordId);
            temp.remove(wrapper.recordId);
            count++;
        }
        IntegrationLogHelper.insertIntegrationLogs();
        if(!temp.isEmpty()){
            MDMMicroServiceQueueable queueable = new MDMMicroServiceQueueable(temp);
            System.enqueueJob(queueable);
        }
    }
}