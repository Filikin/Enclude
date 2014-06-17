// if this event is on a project, then sum all the events on this project
// also sum all this year's events
// include time spent on cases
public with sharing class RollupActivityDaysToProject 
{
	Integer thisYear = system.today().year();
	public RollupActivityDaysToProject (Set <ID> projectIDs)
	{
		List <SFDC_Project__c> projects = [select ID, Total_activity_days__c, (SELECT DurationInMinutes, ActivityDate FROM OpenActivities limit 500), (SELECT DurationInMinutes, ActivityDate FROM ActivityHistories limit 500),
			(select Due_Date__c, Effort_to_resolve_hours__c from Cases__r limit 500) from SFDC_Project__c where ID in :projectIDs limit 500];
		if (projects.size() > 0)
		{
			for (SFDC_Project__c oneProject: projects)
			{
				RollupOneProject (oneProject);
			}
		}
		update projects;
	}

	SFDC_Project__c currentProject;
	public 	RollupActivityDaysToProject (ApexPages.StandardController stdController)
	{
		ID currentProjectID = stdController.getRecord().id;
		currentProject = [select ID, Total_activity_days__c, (SELECT DurationInMinutes, ActivityDate FROM OpenActivities limit 500), (SELECT DurationInMinutes, ActivityDate FROM ActivityHistories limit 500),
		 (select Due_Date__c, Effort_to_resolve_hours__c from Cases__r limit 500) from SFDC_Project__c where ID = :currentProjectID];
	}	

	public pageReference Rollup ()
	{
		RollupOneProject (currentProject);
		update currentProject;
    	String theId = ApexPages.currentPage().getParameters().get('id');
 
    	// Redirect the user back to the original page
        PageReference pageRef = new PageReference('/' + theId);
        pageRef.setRedirect(true);
        return pageRef;
	}	
	
	void RollupOneProject (SFDC_Project__c oneProject)
	{
		if (oneProject.ActivityHistories.size()>0 || oneProject.OpenActivities.size()>0 || oneProject.Cases__r.size()>0)
		{
			oneProject.Total_activity_days__c = 0;
			oneProject.Activity_days_this_year__c = 0;
			for (ActivityHistory oneActivity: oneProject.ActivityHistories)
			{
				if (oneActivity.DurationInMinutes != null) 
				{
					oneProject.Total_activity_days__c += oneActivity.DurationInMinutes;
					if (oneActivity.ActivityDate.year() == thisYear) oneProject.Activity_days_this_year__c += oneActivity.DurationInMinutes;
				}
			}
			for (OpenActivity oneActivity: oneProject.OpenActivities)
			{
				if (oneActivity.DurationInMinutes != null) 
				{
					oneProject.Total_activity_days__c += oneActivity.DurationInMinutes;
					if (oneActivity.ActivityDate.year() == thisYear) oneProject.Activity_days_this_year__c += oneActivity.DurationInMinutes;
				}
			}
			for (Case oneCase: oneProject.Cases__r)
			{
				if (oneCase.Effort_to_resolve_hours__c != null) 
				{
					oneProject.Total_activity_days__c += oneCase.Effort_to_resolve_hours__c * 60;
					if (oneCase.Due_Date__c.year() == thisYear) oneProject.Activity_days_this_year__c += oneCase.Effort_to_resolve_hours__c;
				}
			}
			oneProject.Total_activity_days__c /= (60 * 7.5);
			oneProject.Activity_days_this_year__c /= (60 * 7.5);
		}
	}
}