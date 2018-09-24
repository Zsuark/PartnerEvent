({
    doInit : function(component, event, helper) {
        component.find("forceRecord").getNewRecord(
            "PartnerEvent__c",
            null,
            false,
            $A.getCallback(function() {
                var rec = component.get("v.partnerEvent");
                var error = component.get("v.recordError");
                if (error || (rec === null)) {
                    console.log("Error initializing record template: " + error);
                    return;
                } else {
                    console.log("RECORD INITIALISED!!!");
                    console.log("*** rec: " + JSON.stringify(rec));
                }
            })
        );
    },
    
    saveRecord : function(component, event, helper) {
        
        // Needed fields
        // Event_Name__c, Capacity__c, Date_Time__c, Description__c
        
		// var eventName   = component.find('eventName').get("v.value");
        // var capacity    = parseInt(component.find('capacity').get("v.value"), 10);
        // var dateTime    = component.find("dateTime").get("v.value");
        // var description = component.get("v.descriptionRichText");

        var partnerEvent = component.get("v.partnerEvent");

        console.log("partnerEvent: " + JSON.stringify(partnerEvent));


        var tempRec = component.find("forceRecord");
        /*
        component.set("v.partnerEvent.Event_Name__c",  eventName);
        component.set("v.partnerEvent.Capacity__c",    capacity);
        component.set("v.partnerEvent.Date_Time__c",   dateTime);
        // component.set("v.partnerEvent.Description__c", description);

        console.log("partnerEvent: " +
            JSON.stringify(component.get("v.partnerEvent")));

        console.log("forceRecord: " +
            JSON.stringify(component.find("forceRecord")));
        */

        /*
        alert("eventName: "   + eventName);
        alert("capacity: "    + capacity);
        alert("dateTime: "    + dateTime);
        alert("description: " + description);
        */

        console.log("tempRec: " + JSON.stringify(tempRec));
        tempRec.saveRecord($A.getCallback(function(result) {
            console.log(result.state);
            var resultsToast = $A.get("e.force:showToast");
            // TODO: REMOVE ME!!!!!!!!! (console.log that is)
            console.log("*** RESULT: " + JSON.stringify(result));
            if (result.state === "SUCCESS"  || result.state === "DRAFT") {
                resultsToast.setParams({
                    "title": "Partner Event Created",
                    "message": "The Partner Event was created."
                });
                resultsToast.fire();
                helper.navigateTo(component, result.recordId);
            } else if (result.state === "ERROR") {
                console.log('Error: ' + JSON.stringify(result.error));
                resultsToast.setParams({
                    "title": "Error",
                    "message": "There was an error saving the record: " + JSON.stringify(result.error)
                });
                resultsToast.fire();         
            } else {
                console.log('Unknown problem, state: ' + result.state + ', error: ' + JSON.stringify(result.error));
            }           
        }));
        
    },
    cancelDialog : function(component, helper) {
        var homeEvt = $A.get("e.force:navigateToObjectHome");
        homeEvt.setParams({
            "scope": "PartnerEvent__c"
        });
        homeEvt.fire();
    }
    
    
})