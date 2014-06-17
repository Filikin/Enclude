global class ScheduledSMSResponseCheck implements Schedulable {
	public static String CronExpr='0 0 * * * ?';
	
	
	global static String scheduleCheck() {
        ScheduledSMSResponseCheck everySingleHour = new ScheduledSMSResponseCheck();
        return System.schedule('Hourly SMS server response check', CronExpr, everySingleHour);
    }
	
	global void execute(SchedulableContext SMSReponse) 
	 {
		//A schedule to be set to hourly check how long it has been since the 
		// last sucessful comunication with the SMS server.
     	SMS_Server_Test__c MasterTest = [select Name, Alert_sent__c, Last_response_from_SMS_server__c, Server_not_responding__c 
      	from SMS_Server_Test__c where Name = '0001'];
      	system.assert(MasterTest != null);
      	datetime LastResponse = MasterTest.Last_response_from_SMS_server__c;
      	datetime RightNow = system.now();
      	long dt1 = RightNow.getTime() / 1000 / 60;  //getTime gives us milliseconds, so divide by 1000 for seconds 
      	long dt2 = LastResponse.getTime() / 1000 / 60; //and then devide by 60 for minutes
      	double Difference = (dt1-dt2);
      	
      	if((Difference>=75) && (MasterTest.Alert_sent__c == false))
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

}
}