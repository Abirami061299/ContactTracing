trigger PersonTrigger on Person__c (before insert,after insert,before update,after update,before delete,after delete) {
    
    switch on Trigger.operationType {
        when BEFORE_INSERT {
            PersonTriggerHandler.beforeInsertHandler(Trigger.new);
        }
        when BEFORE_UPDATE {
            PersonTriggerHandler.beforeUpdateHandler(Trigger.oldMap,Trigger.new);
        }
        
        when AFTER_UPDATE {
            PersonTriggerHandler.afterUpdateHandler(Trigger.oldMap,Trigger.new);
        }
      
        
    }
}