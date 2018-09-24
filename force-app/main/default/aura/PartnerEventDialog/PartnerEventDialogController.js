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

    onRecordUpdated:function (component,event,helper) {
    },    
    
    saveRecord : function(component, event, helper) {
        
        // Needed fields
        // Event_Name__c, Capacity__c, Date_Time__c, Description__c
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



        component.find("forceRecord").saveRecord($A.getCallback(function(saveResult) {
            console.log("**************** STATE ***********");
            console.log(saveResult.state);
            var resultsToast = $A.get("e.force:showToast");
            // TODO: REMOVE ME!!!!!!!!! (console.log that is)
            console.log("*** RESULT *** - " + JSON.stringify(saveResult));


            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                // handle component related logic in event handler
                resultsToast.setParams({
                    "title": "Partner Event Created",
                    "message": "The Partner Event was created."
                });
                helper.navigateTo(component, result.recordId);
            } else if (saveResult.state === "INCOMPLETE") {
                resultsToast.setParams({
                    "title": "Offline",
                    "message": "User is offline, device doesn't support drafts."
                });
            } else if (saveResult.state === "ERROR") {
                resultsToast.setParams({
                    "title": "Error",
                    "message": "Unfortunately there was an error saving.\n" +
                                component.get("v.recordError")
                });
                console.log('Problem saving record, error: ' + JSON.stringify(saveResult.error));
            } else {
                resultsToast.setParams({
                    "title": "Unknown problem",
                    "message": "Unfortunately there was a problem saving."
                });
                console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
            }
            resultsToast.fire();         
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