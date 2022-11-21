/*********************************************************************************************************************

Component Name: MDMMicroServiceHelperInvoke

Objective: Test for MDMMicroServiceHelperInvoke

Created Date: 2022-11-16

Created By: Luke Vang

Test Class(es): MDMMicroServiceHelperInvoke_Test

Revision Log:

Developer Name: Luke Vang

**********************************************************************************************************************/
@isTest
public with sharing class MDMMicroServiceHelperInvoke_Test {

    static testMethod void testCallMicroService()
    {
        List<Integration_Setting__mdt> intergrationSettings = [
            SELECT API_Key__c, End_Point__c, Source_Id__c, MasterLabel
            FROM Integration_Setting__mdt
            WHERE End_Point__c != null AND Endpoint_Enabled__c =: true AND Source_Id__c != null LIMIT 1
        ];
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        List<MDMMicroServiceHelperWrapper> wrappers = new List<MDMMicroServiceHelperWrapper>();
        wrappers.add(new MDMMicroServiceHelperWrapper(intergrationSettings[0].MasterLabel, '{"test" : "test"}',  Id.valueOf('0015600000YatpI')));
        Test.startTest();
        MDMMicroServiceHelperInvoke.callMicroService(wrappers);
        Test.stopTest();
        System.assertEquals(1, [SELECT COUNT() FROM Integration_Log__c]);
    }
    
}
