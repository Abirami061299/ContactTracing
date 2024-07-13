({
    doInit: function(component, event, helper){
        component.set('v.columns', [
            {label: 'Id', fieldName: 'id', type: 'text'},
            {label: 'Name', fieldName: 'name', type: 'text'},
            {label: 'Health Status', fieldName: 'status', type: 'text'},
            {label: 'Token', fieldName: 'token', type: 'text'},
            {label: 'Contact Date', fieldName: 'contactDate', type: 'date'},
        ]);

    },
    handleKeyUp: function (component, event,helper) {
       
        var isEnterKey = event.keyCode === 13;
        var recordId = component.find('enter-search').get('v.value');
        if(!recordId){
            component.set("v.personDetail", {});
         }
        if (isEnterKey) {
            component.set('v.issearching', true);
            helper.searchRecord(component,recordId);
        }
    },
})
