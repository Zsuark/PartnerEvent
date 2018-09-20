global class EmailHelper {
    
    global class UtilException extends Exception {}
    
    //  -------------------------------------------------------------------------
    //  HELPER method: sendTemplatedEmail
    //  Originally sourced from: https://developer.salesforce.com/forums/?id=906F000000094ClIAI
    //  -------------------------------------------------------------------------
    global static void sendTemplatedEmail(String[] toRecipients, String[] ccRecipients, String templateApiName, ID targetObjId, Id whatId, ID orgWideEmailId, Boolean saveAsActivity, Attachment[] attachList ) {
        //  templateId   must be ID of an Email template
        //  targetObjId must be a Contact, User, Lead Id -- also used in merge fields of template recipient.xxxx
        //  whatId    must be an SObject that is used in the merge fields of the template relatedTo.xxxx
        //  fromId    if non null, use current user, otherwise, use this ID (most likely an org wide no reply id)
        //  bcc      not permitted when using templates
        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        
        Id templateId;  
        try {templateId = [select id, name from EmailTemplate where developername = : templateApiName].id;}
        catch (Exception e) {
            throw new UtilException ('[U-03] Unable to locate EmailTemplate using name: ' + templateApiName + 
                                     ' refer to Setup | Communications Templates ' + templateApiName);
        }
        
        
        email.setToAddresses(toRecipients);
        email.setCcAddresses(ccRecipients);
        email.setTargetObjectId(targetObjId);
        email.setWhatId(whatId);
        email.setorgWideEmailAddressId(orgWideEmailId);
        email.setTemplateId(templateId);
        email.setSaveAsActivity(saveAsActivity);      // save email as activity on the targetObjId (i.e. Contact). Note activity can't be saved on Users
        
        System.debug(LoggingLevel.INFO,'** entered sendTemplatedEmail, to:' + toRecipients + ' cc:' + ccRecipients +  ' templateId:' + templateId + ' tagetObjId:' + targetObjId + 
                     ' whatId:' + whatId + ' orgWideEmailId: ' + orgWideEmailId);
        try {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            return;
        }
        catch (EmailException e) {
            throw new UtilException('[U-02] sendTemplatedEmail error. ' + e.getMessage());
        }
        
    }  
    
}