# MDM Service Utility Classes

These classes are created to support calling the MDM Microservices from Salesforce. 

These classes are created in such a way that the code has no hard checks for any specific sobject. The integration metadata records are what defines the API endpoints available to be used, and the user only needs to call the service per the examples below. 

## Integration Metadata Record Details

Integration metadata records contain the data required to make API calls to the MDM services.
There must be 2 created per API endpoint. One will point to production and the other to the test environment.
The labels for each API endpoint for each environment must be the same, but the developer name must be unique to the targed environment. 
The utility classes will determine which API endpoint and target targeted environment to call.

|Label|DeveloperName|End Point| Source Id| Help Desk Email Address | Enabled | Environment | Method | 
| ---- | -----------| -------| ----------| ------------------------| ------- | ----------- | ------ | 
| AccountCreated| AccountCreatedProd | https://example.com/ | 1234 | test@test.com | true | Production | POST | 
| AccountCreated| AccountCreatedTest | https://example.com/ | 1234 | test@test.com | true | Sandbox | POST |

# Examples

### Invocable Variables
```
public class MDMMicroServiceHelperWrapper {
    @InvocableVariable
    public String serviceName;
    @InvocableVariable
    public String requestBody;
    @InvocableVariable
    public String recordId;
}
```

### Synchronously 
```
MDMServiceHelper.callMicroService('AccountCreated', '{"accountId" : "<local system id of the account>", "context" : "<account, vendor, broker, customer, guarantor>"}, "recordId");
```

### Invocable Synchronously from flow
```
MDMMicroServiceHelperInvoke.callMDMMicroService(List<MDMMicroServiceHelperWrapper> wrappers);
```


### Asynchronously 
```
MDMServiceHelper.callMicroServiceFuture('AccountCreated', '{"accountId" : "<local system id of the account>", "context" : "<account, vendor, broker, customer, guarantor>"}, "recordId");
```

### Invocable Asynchronously from flow
```
MDMMicroServiceHelperInvoke.callMicroServiceFuture(List<MDMMicroServiceHelperWrapper> wrappers);
```
