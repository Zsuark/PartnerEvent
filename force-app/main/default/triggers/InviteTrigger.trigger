trigger InviteTrigger on Invite__c (after insert, before update) {

    // TODO What about data loading?

    if (Trigger.isInsert) {
        // We need to send invite emails for every Invite created

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
    else if (Trigger.isUpdate) {
        // We need to ensure that the number of accepted invitations
        // do not exceed the capacity of the PartnerEvent

        // Just grab the invites that statuses are being updated to
        // 'accepted' from another status.
        List<Invite__c> updatedInvites = new List<Invite__c>();
        Set<Id> partnerEventIdSet = new Set<Id>();
        for (Invite__c invite: Trigger.new) {
            Invite__c oldInvite =  Trigger.oldMap.get(invite.Id);
            if (invite.Status__c == 'accepted'
                && oldInvite.Status__c != 'accepted') {
                updatedInvites.add(invite);
                partnerEventIdSet.add(invite.PartnerEvent__c);
            }
        }

        // stop processing if there are no invites with status
        // updated to 'accepted'
        if (updatedInvites.size() == 0) return;


        Map<Id, PartnerEvent__c> partnerEventMap = new Map<Id, PartnerEvent__c>([
            SELECT Id, Capacity__c
            FROM PartnerEvent__c
            WHERE Id IN :partnerEventIdSet
        ]);

        List<AggregateResult> countResults = [
            SELECT PartnerEvent__c, COUNT(Id) acceptedCount
            FROM Invite__c
            WHERE PartnerEvent__c IN :partnerEventIdSet
            AND Status__c = 'accepted'
            GROUP BY PartnerEvent__c
            ORDER BY PartnerEvent__c
        ];

        Map<Id, Integer> acceptedCountMap = new Map<Id, Integer>();
        for (AggregateResult countResult : countResults) {
            Id partnerEventId = (Id) countResult.get('PartnerEvent__c');
            Integer acceptedCount = (Integer) countResult.get('acceptedCount');
            acceptedCountMap.put(partnerEventId, acceptedCount);
        }

        for (Invite__c invite : updatedInvites) {
            Id partnerEventId = invite.PartnerEvent__c;
            Integer capacity = (Integer) partnerEventMap.get(partnerEventId).Capacity__c;

            if (acceptedCountMap.containsKey(partnerEventId)) {
                Integer acceptedCount = acceptedCountMap.get(partnerEventId);

                if (acceptedCount < capacity) {
                    acceptedCountMap.put(partnerEventId, acceptedCount + 1);
                } else {
                    invite.Status__c = 'declined';
                }

            } else {
                acceptedCountMap.put(partnerEventId, 1);
            }

        }

    }
     
}