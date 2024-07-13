({
    updateStatus : function(component) {
        let recordId=component.get('v.recordId');
        let action = component.get('c.updateHealthStatus');
        action.setParams({"personId":recordId});
        action.setCallback(this, function(response){
           const state = response.getState();
           if (state === "SUCCESS") {
            this.showToast('Success','Person Health Status Updated','success');

           }
        });
        $A.enqueueAction(action);
    },
    showToast : function(title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type":type
        });
        toastEvent.fire();
    }
})
