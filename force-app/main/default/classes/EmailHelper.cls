public class EmailHelper {
    
    public class UtilException extends Exception {}
    
    //  -------------------------------------------------------------------------
    //  HELPER method: sendTemplatedEmail
    //  Based on examples from:
    //   - https://developer.salesforce.com/forums/?id=906F000000094ClIAI
    //   - https://salesforce.stackexchange.com/questions/127287/send-email-to-list-of-contacts
    //  -------------------------------------------------------------------------
    public static List<Messaging.SendEmailResult> sendInviteEmail(Map<Id, List<Id>> eventContactMap) {
        // Takes a Map of PartnerEvent__c Ids to a List of Contact Ids
                        
        EmailTemplate template = [Select id from EmailTemplate where DeveloperName = 'EmailInvite'];
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        
        for (Id partnerEventId : eventContactMap.keySet()) {
            List<Id> contactIdList = eventContactMap.get(partnerEventId);
            for (Id c : contactIdList)
            {
                Messaging.SingleEmailMessage email
                    = new Messaging.SingleEmailMessage();
                email.setTemplateID(template.Id);
                email.setWhatId(partnerEventId);
                email.setTargetObjectId(c);
                emailList.add(email);
            }
        }
        return Messaging.sendEmail(emailList, false);
        
    }  
    
}