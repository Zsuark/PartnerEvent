public class PartnerEventsController {
    @AuraEnabled
    public static List<PartnerEvent__c> getPartnerEvents() {
    	return [
    		SELECT Capacity__c, CreatedBy.Name, Date_Time__c, Description__c, Event_Name__c
        	FROM PartnerEvent__c
        	ORDER BY Date_Time__c DESC
       	];        
    }

}