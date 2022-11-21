/*********************************************************************************************************************

   Component Name: IntegrationLogHelper_Test

   Objective: Test for IntegrationLogHelper

   Created Date: 2022-11-16

   Created By: Luke Vang

   Test Class(es): IntegrationLogHelper_Test

   Revision Log:

   Developer Name: Luke Vang

 **********************************************************************************************************************/
@isTest
public with sharing class IntegrationLogHelper_Test {

    static testMethod void testAddIntegrationLog()
    {
        HttpRequest req = new HttpRequest();
        req.setBody(JSON.serialize(new Map<String, String> { 'attribute' => 'test'}));
        HttpResponse resp = new HttpResponse();
        resp.setBody(JSON.serialize(new Map<String, String> { 'attribute' => 'test'}));
        resp.setStatusCode(200);

        Test.startTest();
        IntegrationLogHelper.addIntegrationLog(req, resp, Id.valueOf('0015600000YatpI'));
        IntegrationLogHelper.insertIntegrationLogs();
        Test.stopTest();
        System.assertEquals(1, [SELECT COUNT() FROM Integration_Log__c]);
    }


    static testMethod void testAddIntegrationLogException(){
        Test.startTest();
        try{
           Integer i = 1 / 0;
        }catch(Exception ex) {
            IntegrationLogHelper.addIntegrationLogException(ex, Id.valueOf('0015600000YatpI'));
        }finally{
            IntegrationLogHelper.insertIntegrationLogs();
        }
        Test.stopTest();
        System.assertEquals(1, [SELECT COUNT() FROM Integration_Log__c]);
    }
}
