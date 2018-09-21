@RestResource(urlMapping='/Invite/*')
global with sharing class InviteRestResource {
	@HttpPatch
    global static String setInviteReply(Id inviteId, String reply) {
        return 'declined';
    }
}