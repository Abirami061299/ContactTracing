({
    searchRecord : function(component,recordId) {
        let action = component.get('c.getPersonDetails');

        action.setParams({"recordId":recordId});
        action.setCallback(this, function(response){
           const state = response.getState();
           console.log(response);
           if (state === "SUCCESS") {
            let personRes=response.getReturnValue();
            if(!personRes || !personRes.name){
                component.set("v.userFound",false);
               this.showToast('Error','Please Enter Valid User Id','error');
            }
            else{
              component.set("v.personDetail", personRes);
              component.set("v.userFound",true);
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
