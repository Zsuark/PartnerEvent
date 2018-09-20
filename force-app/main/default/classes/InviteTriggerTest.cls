@isTest
public class InviteTriggerTest {

    public static testmethod void testValidateInvite() {
        
        Test.startTest();
        DateTime eventDate = DateTime.now().addDays(2);
        
        PartnerEvent__c testEvent = new PartnerEvent__c(
            Date_Time__c = eventDate,
            Description__c = 'Test event description',
            Event_Name__c = 'Test event name',
            Capacity__c = 5            
        );
        insert testEvent;
        
        Contact c1 = new Contact(
            FirstName = 'Test',
        	LastName  = 'User1',
        	Email='contact1@example.com'
        );
        
        Contact c2 = new Contact();
        c2.firstName = 'Test';
        c2.LastName = 'User2';
        c2.Email = 'contact2@example.com';
        insert new List<Contact> { c1, c2};


        
        Invite__c i1 = new Invite__c(
            PartnerEvent__c = testEvent.Id,
            Contact__c = c1.Id
        );
        
        Invite__c i2 = new Invite__c(
            PartnerEvent__c = testEvent.Id,
            Contact__c = c2.Id
        );
        
        insert new List<Invite__c> { i1, i2 };
        
        // Note - multiple emails are sent at once - so there should only be a single invocation in this case.
        Integer invocations = Limits.getEmailInvocations();
        Test.stopTest();
        
        System.assertEquals(1, invocations);
    }    
}