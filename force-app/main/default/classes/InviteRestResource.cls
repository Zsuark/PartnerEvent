@RestResource(urlMapping='/invite')
global with sharing class InviteRestResource {
	
	@HttpPatch
    global static String updateStatus() {

	    RestRequest request = RestContext.request;

	    Map<String, Object> params = (Map<String, Object>)
	    	JSON.deserializeUntyped(request.requestbody.tostring());

	    if (! params.containsKey('id')) {
	    	return 'ERROR: Invite ID not given in request';
	    }

	    if (! params.containsKey('status')) {
	    	return 'ERROR: Invite status not given in request';
	    }

	    Id inviteId  = (Id) params.get('id');
	    Id status = (String) params.get('status');

	    Invite__c invite = new Invite__c(Id = inviteId, Status__c = status);
	    try {
	    	update invite;
	    } catch (DmlException e) {
	    	return 'ERROR: DML Exception occured when trying to update invite with ID '
	    		+ inviteId + ' and Status__c of \'' + status + '\'';
	    }

	    invite = [
	    	SELECT Status__c
	    	FROM Invite__c
	    	WHERE Id = :inviteId
	    ];

	    return invite.Status__c;
    }
}