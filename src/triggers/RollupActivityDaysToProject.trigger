trigger RollupActivityDaysToProject on Event (after insert, after update) 
{
	// if this event is on a project, then sum all the events on this project
	set <ID> projectIDs = new set<ID>();
	for (Event oneEvent: trigger.new)
	{
		if (oneEvent.WhatId != null && 'SFDC_Project__c' == oneEvent.WhatId.getSObjectType().getDescribe().getName())
		{
			projectIDs.add (oneEvent.WhatId);
		}
	}
	RollupActivityDaysToProject roll = new RollupActivityDaysToProject (projectIDs);
}