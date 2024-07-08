public with sharing class PersonTriggerHandler {
    
    public static void beforeInsertHandler(List<Person__c> newPersons){
        for(Person__c person:newPersons){
            person.Health_Status__c='green';
            person.Token__c=CTPersonController.getToken(person.Mobile__c);
            person.Status_Update_Date__c= Date.today();
            }

    }
    public static void beforeUpdateHandler(Map<Id,Person__c> oldpersonsMap,List<Person__c> newPersons){
        for(Person__c person:newPersons){
            if(person.Health_Status__c != oldpersonsMap.get(person.Id).Health_Status__c){
                person.Status_Update_Date__c= Date.today();
            
            }
    }
    }
   public static void afterUpdateHandler(Map<Id,Person__c> oldpersonsMap,List<Person__c> newPersons){
    Set<Id> statusChange = new Set<Id>();
    Set<Id> redStatus = new Set<Id>();

    for(Person__c person:newPersons){
        if(person.Health_Status__c != oldpersonsMap.get(person.Id).Health_Status__c){
            statusChange.add(person.Id);
        }
        if(person.Health_Status__c == 'Red' && oldpersonsMap.get(person.Id).Health_Status__c != 'Red'){
            redStatus.add(person.Id);
        }
        
    }

    Set<Id> alreadyProcessed=new Set<Id>();
    alreadyProcessed.addAll(redStatus);

    Set<Id> orangeStatus = new Set<Id>();
    Set<Id> yellowStatus = new Set<Id>();
    
    List<Person__c> personToUpdate=new List<Person__c>();
    // lets add cohabitants
    orangeStatus.addAll(CTPersonController.getCohabitants(redStatus,alreadyProcessed));
    // lets add primaryContacts
    Set<Id> primaryContacts= CTPersonController.getPrimaryContacts(redStatus,alreadyProcessed);
    orangeStatus.addAll(primaryContacts);

    // lets add neighbors
    yellowStatus.addAll(CTPersonController.getNeighbors(redStatus,alreadyProcessed));
   
    // lets add secondaryContacts
    yellowStatus.addAll(CTPersonController.getSecondaryContacts(primaryContacts,alreadyProcessed));


    for(Id pid:orangeStatus){
        personToUpdate.add(new Person__c(Id=pid,Health_Status__c='Orange'));
    }

    for(Id pid:yellowStatus){
        personToUpdate.add(new Person__c(Id=pid,Health_Status__c='Yellow'));
    }
    if(personToUpdate.size()>0){
        update personToUpdate;

    }
    List<Location_Tracing__c> locationTraces= CTLocationTracingController.getLocationsByPersonIds(statusChange);
    Set<Id> locationIds=new Set<Id>();
    for(Location_Tracing__c locTrace:locationTraces){
        locationIds.add(locTrace.Location__c);
    }
    CTLocationController.updateRedScore(locationIds);
}
}