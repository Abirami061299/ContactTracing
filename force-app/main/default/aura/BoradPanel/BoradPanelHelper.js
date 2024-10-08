({
    addResult : function(component,gameResult) {
        const action=component.get('c.addResult');
        const modeValue=component.get('v.selectedMode').toUpperCase();
        action.setParams({result:gameResult,mode:modeValue});
        action.setCallback(this,function(response){
            let state=response.getState();
            if(state!='SUCCESS'){
                console.log('Error in saving the record');
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
