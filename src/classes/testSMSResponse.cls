@isTest
class testSMSResponse {
	
	static testmethod void ScheduledSMSResponseCheck(){
		SMS_Server_Test__c MasterTest = new SMS_Server_Test__c (Last_response_from_SMS_server__c= system.now(),
		Server_not_responding__c = false);
		insert MasterTest;
      
      	datetime LastResponse = MasterTest.Last_response_from_SMS_server__c;
      	datetime RightNow = system.now();
      	long dt1 = RightNow.getTime() / 1000 / 60;  //getTime gives us milliseconds, so divide by 1000 for seconds 
      	long dt2 = (LastResponse.getTime() / 1000 / 60)- 80; //and then devide by 60 for minutes
      	double Difference = (dt1-dt2);
      	system.assertEquals(Difference, 80);
      	
      	if((Difference>=75) && (MasterTest.Server_not_responding__c == false))
      	//Checks that an SMS reply has been received with in the last 75 minutes
      	{
      		MasterTest.Server_not_responding__c = true;
      		update MasterTest;
      	}
      	else
      	{
      		MasterTest.Server_not_responding__c = false;
      		update MasterTest;
      	}
     boolean check = MasterTest.Server_not_responding__c;
     system.assertEquals(true, check);
    
	}
	
}