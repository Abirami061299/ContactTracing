({
    searchRecord : function(component,recordId) {
        let action = component.get('c.getLocationDetails');

        action.setParams({"recordId":recordId});
        action.setCallback(this, function(response){
           const state = response.getState();
           console.log(response);
           if (state === "SUCCESS") {
            let locationRes=response.getReturnValue();
            if(!locationRes || !locationRes.name){
                component.set("v.locationFound",false);
               this.showToast('Error','Please Enter Valid Location Id','error');
            }
            else{
              component.set("v.locationDetail", locationRes);
              component.set("v.locationFound",true);
            }
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
