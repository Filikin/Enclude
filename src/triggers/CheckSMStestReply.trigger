trigger CheckSMStestReply on SMS__c (after update) {
	//for (SMS__c obj: trigger.new){
		
	SMS__c LastSMS = trigger.new[0];
	/**String SMSid = LastSMS.Name;
	
	SMS__c testSMS = [Select Name, To_Mobile__c, Message_Received__c 
	From SMS__c
	Where To_Mobile__c = '0851289423'];*/
	
	if (LastSMS.To_Mobile__c == '0851289423')
	{	
		if (LastSMS.Message_Received__c == true)
		{
			SMS_Server_Test__c MasterTest = [Select Name, Alert_sent__c, Server_not_responding__c, Last_response_from_SMS_server__c
			From SMS_Server_Test__c
			Where Name = '0001'];
			MasterTest.Last_response_from_SMS_server__c = System.now();
			MasterTest.Alert_sent__c = false;
			update MasterTest;
		}
	}
	
	

}