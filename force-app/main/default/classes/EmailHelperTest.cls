@isTest
public class EmailHelperTest {
    // See: https://apexandbeyond.wordpress.com/2017/07/30/unit-testing-code-that-sends-email/
    // for info on testing email
    
    public static testmethod void testvalidate(){
        
        Test.startTest();
        DateTime eventDate = DateTime.now().addDays(2);
        
        PartnerEvent__c testEvent = new PartnerEvent__c(
            Date_Time__c = eventDate,
            Description__c = 'Test event description',
            Event_Name__c = 'Test event name',
            Capacity__c = 5            
        );
        insert testEvent;
        
        List<Contact> contactList = new List<Contact>();
        
        Contact c = new Contact();
        c.FirstName = 'Raphael';
        c.LastName  = 'Krausz';
        c.email='contact1@example.com';
        insert c;
        contactList.add(c);
        
        Contact c2 = new Contact();
        c2.firstName = 'Raphael';
        c2.LastName = 'Krausz';
        c2.Email = 'contact2@example.com';
        insert c2;
        contactList.add(c2);
        
        List<Messaging.SendEmailResult> results = EmailHelper.sendInviteEmail(contactList, testEvent.Id);

        // Note - multiple emails are sent at once - so there should only be a single invocation in this case.
        Integer invocations = Limits.getEmailInvocations();
        Test.stopTest();
        
        System.assertEquals(1, invocations);
        System.assertEquals(2, results.size());
        for (Messaging.SendEmailResult result : results) {
            System.debug('result: ' + result);
			System.assert(result.success);
        }
    }
}