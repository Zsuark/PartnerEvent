@RestResource(urlMapping='/invite')
global with sharing class InviteRestResource {
	
	@HttpPatch
    global static void updateStatus() {

	    RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

	    if (! req.params.containsKey('id')) {
            res.statusCode = 400;            
            res.responseBody = Blob.valueOf(JSON.serialize(
                new Map<String, String> {'error' => 'Invite ID not given in request'}));
            return;
	    }

	    if (! req.params.containsKey('status')) {
            res.statusCode = 400;
            res.responseBody = Blob.valueOf(JSON.serialize(
                new Map<String, String> {'error' => 'Invite status not given in request'}));
            return;
	    }

	    String inviteId  = req.params.get('id');
	    String status    = req.params.get('status');

	    Invite__c invite = new Invite__c(Id = inviteId, Status__c = status);
	    try {
	    	update invite;
	    } catch (DmlException e) {
            res.statusCode = 500;

            res.responseBody =
                Blob.valueOf(JSON.serialize(new Map<String, String> {
                    'error' => 'DML Exception occured when trying to update invite with ID '
                        + inviteId + ' and Status__c of \'' + status + '\'\n',
                    'exception' => e.getMessage()
            }));
            return;
	    }

	    invite = [
	    	SELECT Status__c
	    	FROM Invite__c
	    	WHERE Id = :inviteId
	    ];
        
        res.statusCode = 200;
        res.responseBody = Blob.valueOf(JSON.serialize(invite));

    }
}