//Because of the possible confusion with the inclusion of 'test' in the name, to clarify,
//this is not a test, it is a scheduled SMS object creation for testing purposes.
//The class that tests this class is called 'testSMStestingclass'
global class SMStestScheduler implements Schedulable {
	public static String CronExp='0 0 * * * ?';
	
	
	global static String scheduleIt() {
        SMStestScheduler everyHr = new SMStestScheduler();
        return System.schedule('Hourly test', CronExp, everyHr);
    }
	
	 global void execute(SchedulableContext SC) 
	 {
	 
      	Contact testSMScontact = [select LastName, MobilePhone from Contact where MobilePhone = '0851289423'];
    	SMS__c SMStesteveryhour = new SMS__c ( To_Contact__c = testSMScontact.id, Outgoing_Message__c = 'This should return as a reply');
		
		insert SMStesteveryhour;
     	
     }
}