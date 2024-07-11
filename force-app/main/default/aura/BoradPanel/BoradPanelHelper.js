({
    addResult : function(component,gameResult) {
        const action=component.get('c.addResult');
        const modeValue=component.get('v.selectedMode').toUpperCase();
        action.setParams({result:gameResult,mode:modeValue});
        action.setCallback(this,function(response){
            let state=response.getState();
            if(state!='Success'){
                console.log('Error in saving the record');
            }
        });
        $A.enqueueAction(action);
    }
})
