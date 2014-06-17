@isTest
private class TestRollupOnProject {

    static testMethod void ProjectRollupTest() 
    {
    	SFDC_Project__c oneProject = new SFDC_Project__c (Name='test');
    	insert oneProject;
    	
    	Contact testPerson = new Contact (LastName = 'me');
    	insert testPerson;
    	Event od1 = new Event (WhoID = testPerson.id, WhatID = oneProject.id, OwnerID=UserInfo.getUserId(), StartDateTime=DateTime.newInstance(2012,1,4,1,1,1), Subject='Test');
		od1.DurationInMinutes=60*15;
		insert od1;

		SFDC_Project__c resultProject = [select ID, Total_activity_days__c, (SELECT DurationInMinutes FROM OpenActivities), (SELECT DurationInMinutes FROM ActivityHistories) from SFDC_Project__c where Name='test' limit 1];

		ApexPages.StandardController projectController = new ApexPages.StandardController(resultProject);
    	RollupActivityDaysToProject roll = new RollupActivityDaysToProject(projectController);	
    	roll.Rollup();	
// 		resultProject = [select ID, Total_activity_days__c, (SELECT DurationInMinutes FROM OpenActivities), (SELECT DurationInMinutes FROM ActivityHistories) from SFDC_Project__c where Name='test' limit 1];
//    	system.assertEquals (2, resultProject.Total_activity_days__c);    	
    }
}