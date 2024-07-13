({
    fetchRecentHealthChanges : function(component) {
        let scope=component.get('v.scope');
        let action = scope === 'person' ? component.get('c.getRecentPersonHealthChanges'): component.get('c.getRecentLocationHealthChanges');
        action.setCallback(this, function(response){
           const state = response.getState();
   
           if (state === "SUCCESS") {
             component.set("v.data", response.getReturnValue());
             component.set("v.initialResponse", response.getReturnValue());

           }
        });
        $A.enqueueAction(action);
    },
    searchRecord : function(component,searchTerm) {
        let scope=component.get('v.scope');
        let action = scope === 'person' ? component.get('c.searchPeople'): component.get('c.searchLocation');
        action.setParams({"searchTerm":searchTerm});
        action.setCallback(this, function(response){
           const state = response.getState();
   
           if (state === "SUCCESS") {
            let data=response.getReturnValue();
            if(data && data.length>0){
                component.set("v.data", data);

            }
           }
        });
        $A.enqueueAction(action);
    }
})
