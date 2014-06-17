trigger RollupCaseDaysToProject on Case (after insert, after update) 
{
	// if this case is on a project, then sum all the events and cases on this project
	set <ID> projectIDs = new set<ID>();
	for (Case oneCase: trigger.new)
	{
		if (oneCase.Project__c != null)
		{
			projectIDs.add (oneCase.Project__c);
		}
	}
	if (projectIDs.size() > 0) RollupActivityDaysToProject roll = new RollupActivityDaysToProject (projectIDs);

}