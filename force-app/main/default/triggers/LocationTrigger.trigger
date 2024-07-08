trigger LocationTrigger on Location__c (before insert,after insert,before update,after update,before delete,after delete) {
    switch on Trigger.operationType {
        when BEFORE_INSERT {
            LocationTriggerHandler.beforeInsertHandler(Trigger.new);
        }
        when BEFORE_UPDATE {
            LocationTriggerHandler.beforeUpdateHandler(Trigger.oldMap,Trigger.new);
        }
        
        when AFTER_UPDATE {
            LocationTriggerHandler.afterUpdateHandler(Trigger.oldMap,Trigger.new);
        }
      
        
    }
}