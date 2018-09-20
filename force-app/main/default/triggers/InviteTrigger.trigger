trigger InviteTrigger on Invite__c (after insert) {

    // Map PartnerEvent.Id to list of contacts
    Map<Id, List<Id>> eventContactMap = new Map<Id, List<Id>>();
    
    for (Invite__c invite : Trigger.new) {
        
        Id partnerEventId = invite.PartnerEvent__c;
        Id contactId = invite.Contact__c;
        
        if (eventContactMap.containsKey(partnerEventId)) {
            List<Id> contactIdList = eventContactMap.get(partnerEventId);
            contactIdList.add(contactId);
        }
        else {
            List<Id> contactIdList = new List<Id> { contactId };
            eventContactMap.put(partnerEventId, contactIdList);
        }        
    }
    
    if (eventContactMap.size() > 0) {
        EmailHelper.sendInviteEmail(eventContactMap);
    }
     
}