@isTest
private class testCheckSMStestReply 
{
    static testMethod void testCheckSMStestReply() 
    {
    	
    	Contact John = new Contact(FirstName = 'John',
    	LastName = 'Smith',
    	MobilePhone = '0851289423');
    	insert John;
    	
    	SMS_Server_Test__c MasterTest = new SMS_Server_Test__c (Name = '0001');
    	insert MasterTest;
    	SMS__c text = new SMS__c (To_Contact__c = John.ID,
    	Message_Received__c = true);
    	insert text;
    	update text;
    	
    }
}