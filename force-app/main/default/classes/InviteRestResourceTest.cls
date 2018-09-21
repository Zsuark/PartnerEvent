@isTest
public class InviteRestResourceTest {

	public static testmethod void testUpdateStatusHappyPath() {

		DateTime eventDate = DateTime.now().addDays(2);
        
        PartnerEvent__c testEvent = new PartnerEvent__c(
            Date_Time__c = eventDate,
            Description__c = 'Test event description',
            Event_Name__c = 'Test event name',
            Capacity__c = 5            
        );
        insert testEvent;
        
        List<Id> contactIdList = new List<Id>();
        
        Contact c = new Contact();
        c.FirstName = 'Test';
        c.LastName  = 'User1';
        c.email='contact1@example.com';
        insert c;

        Invite__c invite = new Invite__c(
        	PartnerEvent__c = testEvent.Id,
        	Contact__c = c.Id
        );
        insert invite;
        Id inviteId = invite.Id;


   		Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/invite'; 
        req.params.put('id', invite.Id);
        req.params.put('status', 'accepted');
        req.httpMethod = 'PATCH';
        req.addHeader('Content-Type', 'application/json'); 
        RestContext.request = req;
        RestContext.response = res;
        InviteRestResource.updateStatus();
        System.debug('res: ' + res);
        System.assertEquals(200, res.statusCode);

        invite = (Invite__c) JSON.deserialize(res.responseBody.toString(), Invite__c.class);
        System.assertEquals('accepted', invite.Status__c);
        System.assertEquals(inviteId, invite.Id);
	   	Test.stopTest();   
	}

}