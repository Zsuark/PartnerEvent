({
    doInit : function(component, event, helper) {
        component.find("forceRecord").getNewRecord(
            "PartnerEvent__c",
            null,
            false,
            $A.getCallback(function() {
                var rec = component.get("v.partnerEventRecord");
                var error = component.get("v.recordError");
                if (error || (rec === null)) {
                    console.log("Error initializing record template: " + error);
                    return;
                }
            })
        );
    },
    
    saveRecord : function(component, event, helper) {
        
        // Needed fields
        // Event_Name__c, Capacity__c, Date_Time__c, Description__c
        
        component.set("v.partnerEventRecord.Event_Name__c", component.find('eventName').get("v.value"));
        
        var capacity = parseInt(component.find('capacity').get("v.value"), 10);
        
        component.set("v.partnerEventRecord.Capacity__c", capacity);
        component.set("v.partnerEventRecord.Date_Time__c", component.find('dateTime').get("v.value"));
        component.set("v.partnerEventRecord.Description__c", component.find('description').get("v.value"));
        
        var tempRec = component.find("forceRecord");
        tempRec.saveRecord($A.getCallback(function(result) {
            console.log(result.state);
            var resultsToast = $A.get("e.force:showToast");
            if (result.state === "SUCCESS") {
                resultsToast.setParams({
                    "title": "Saved",
                    "message": "The record was saved."
                });
                resultsToast.fire();                
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
        
    }
    
})