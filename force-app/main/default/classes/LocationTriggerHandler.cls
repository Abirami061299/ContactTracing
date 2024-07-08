public with sharing class LocationTriggerHandler {
    public static void beforeInsertHandler(List<Location__c> newLocations){
        for(Location__c location:newLocations){
            location.Status__c='Green';
            location.Status_Update_Date__c= Date.today();
        }

    }
    public static void beforeUpdateHandler(Map<Id,Location__c> oldLocationsMap,List<Location__c> newLocations){
        for(Location__c location:newLocations){
            if(location.Status__c != oldLocationsMap.get(location.Id).Status__c){
                location.Status_Update_Date__c= Date.today();
            
            }
    }
    }
    public static void afterUpdateHandler(Map<Id,Location__c> oldLocationsMap,List<Location__c> newLocation){
        Set<Id> locationIds=new Set<Id>();
        for(Location__c location:newLocation){
            if(location.Status__c == 'Red' && location.Status__c != oldLocationsMap.get(location.Id).Status__c){
                locationIds.add(location.Id);
            }
            
        }
        List<Location_Tracing__c> locationTraces = CTLocationTracingController.getLocationsByLocationIds(locationIds);
        Set<Id> personIds = new Set<Id>();
        for(Location_Tracing__c location:locationTraces){
            personIds.add(location.Person__c);
        }
        List<Person__c> personToUpdate=new List<Person__c>();
       
        for(Id pid:personIds){
            personToUpdate.add(new Person__c(Id=pid,Health_Status__c = 'Yellow'));
        }
        if(personToUpdate.size()>0){
            update personToUpdate;

        }
    }
}