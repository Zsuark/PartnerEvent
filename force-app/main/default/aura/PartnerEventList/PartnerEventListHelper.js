({
    // Fetch the accounts from the Apex controller
    getPartnerEventList: function(component) {
        var action = component.get('c.getPartnerEvents');
        var self = this;
        action.setCallback(this, function(actionResult) {
            component.set('v.partnerEvents', actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
    }
})