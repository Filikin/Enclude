@isTest
private class testSMScheck 
{
    static testMethod void CheckSMStestReply() 
    {
    	SMS_Server_Test__c testobj = new SMS_Server_Test__c (Server_not_responding__c = false);
    	insert testobj;
    	Contact person = new Contact (LastName = 'Me', FirstName = 'Only');
    	SMS__c checkSMS = new SMS__c (To_Contact__c = person.Id, Message_Received__c = false);
    	insert person;
    	insert checkSMS;
    	checkSMS.Message_Received__c= true;
    	//update checkSMS;
    	
    	system.assertEquals(true, checkSMS.Message_Received__c);
    	boolean check = (testobj.Last_response_from_SMS_server__c == system.now());
    	system.assertEquals(check, false);
    }
}