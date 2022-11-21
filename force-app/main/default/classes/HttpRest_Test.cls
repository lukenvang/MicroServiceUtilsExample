/*********************************************************************************************************************

Component Name: HttpRest_Test

Objective: Test class for HttpRest

Created Date: 2022-11-16

Created By: Luke Vang

Test Class(es): n/a

Revision Log:

Developer Name: Luke Vang

**********************************************************************************************************************/
@isTest
public with sharing class HttpRest_Test {
    
    static testMethod void testDoCallout()
    {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        HttpRest.doCallout('https://www.google.com/', 'test', 'POST', Id.valueOf('0015600000YatpI'), new Map<String, String> { 'authorization' => 'test'});
        Test.stopTest();
        System.assertEquals(1, [SELECT COUNT() FROM Integration_Log__c]);
    }   
}
