public with sharing class WheelChartController 
{
    Contact client=null;
    List<WheelPointData> data = new List<WheelPointData>();
    
    public List<WheelPointData> getWheelData() 
    {
        return data;
    }

    // Wrapper class
    public class WheelPointData 
    {
        public String name { get; set; }
        public Integer data1 { get; set; }
        public Integer data2 { get; set; }
        public Integer data3 { get; set; }
        public Integer data4 { get; set; }

        public WheelPointData(List<Outcome_Wheel__c> outcomeWheels, String fieldlabel, String fieldname)
        {
            try
            {
                this.name = fieldlabel;
                this.data1 = (Integer)(Decimal)(outcomeWheels[0].get(fieldname)!=null?outcomeWheels[0].get(fieldname):0);
                this.data2 = (Integer)(Decimal)(outcomeWheels.size()>1 && outcomeWheels[1].get(fieldname)!=null ? outcomeWheels[1].get(fieldname):0);
                this.data3 = (Integer)(Decimal)(outcomeWheels.size()>2 && outcomeWheels[2].get(fieldname)!=null ? outcomeWheels[2].get(fieldname):0);
                this.data4 = (Integer)(Decimal)(outcomeWheels.size()>3 && outcomeWheels[3].get(fieldname)!=null ? outcomeWheels[3].get(fieldname):0);
            }
            catch (Exception e)
            {
                system.debug (e);
                this.name = '';
                this.data1 = 0;
                this.data2 = 0;
                this.data3 = 0;
                this.data4 = 0;
            }
        }
    }
    
    public WheelChartController(ApexPages.StandardController controller)
    {
        client = (Contact)controller.getRecord();
    }
    
    public Boolean getAnyData ()
    {
        return data.size() > 0;
    }
    
    public void extractData ()
    {
       List<Outcome_Wheel__c> outcomeWheels = [select Stage__c, X1__c, X2__c, X3__c, X4__c, X5__c,
                X6__c, X7__c, X8__c, X9__c, X10__c 
                from Outcome_Wheel__c where Client__c = :client.id order by Date_of_completion__c asc];
        if (outcomeWheels.size() > 0)
        {
             data.add (new WheelPointData (outcomeWheels, Outcome_Wheel__c.X1__c.getDescribe().getLabel(), 'X1__c'));
            data.add (new WheelPointData (outcomeWheels, Outcome_Wheel__c.X2__c.getDescribe().getLabel(), 'X2__c'));
            data.add (new WheelPointData (outcomeWheels, Outcome_Wheel__c.X3__c.getDescribe().getlabel(), 'X3__c'));         
            data.add (new WheelPointData (outcomeWheels, Outcome_Wheel__c.X4__c.getDescribe().getlabel(), 'X4__c'));           
            data.add (new WheelPointData (outcomeWheels, Outcome_Wheel__c.X5__c.getDescribe().getlabel(), 'X5__c'));           
            data.add (new WheelPointData (outcomeWheels, Outcome_Wheel__c.X6__c.getDescribe().getlabel(), 'X6__c'));           
            data.add (new WheelPointData (outcomeWheels, Outcome_Wheel__c.X7__c.getDescribe().getlabel(), 'X7__c'));         
            data.add (new WheelPointData (outcomeWheels, Outcome_Wheel__c.X8__c.getDescribe().getlabel(), 'X8__c'));         
            data.add (new WheelPointData (outcomeWheels, Outcome_Wheel__c.X9__c.getDescribe().getlabel(), 'X9__c'));         
            data.add (new WheelPointData (outcomeWheels, Outcome_Wheel__c.X10__c.getDescribe().getlabel(), 'X10__c'));
            
        }
    }
    
    public static testMethod void testSampleData ()
    {
    	Contact client = new Contact (Lastname='Bloggs');
    	insert client;
    	      
    	Outcome_Wheel__c outcomeWheel = new Outcome_Wheel__c (Stage__c='Admission', X1__c=2, X2__c=2, X3__c=2, X4__c=2, X5__c=2,
                X6__c=2, X7__c=2, X8__c=2, X9__c=2, X10__c=2, Client__c = client.id, Date_of_completion__c=system.today());
        insert outcomeWheel;
    	
    	ApexPages.StandardController wheelControllerPage = new ApexPages.StandardController(client);
    	WheelChartController wheel = new WheelChartController (wheelControllerPage);
    	wheel.extractData();
    	system.assert (wheel.getAnyData());
    	wheel.getWheelData();
    }
}