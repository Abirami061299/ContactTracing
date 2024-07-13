public with sharing class CTLocationTracingController {
    public CTLocationTracingController() {

    }
     /**
     * getVisitors based on locationTracingId 
     * @param locationTracingId
     * @return List<Location_Tracing__c>
    */
    public static List<Location_Tracing__c> getVisitors(String locationTracingId){
        return [SELECT Id, Name, Person__c,Person__r.Name,
                Person__r.Health_Status__c,Person__r.Token__c, 
                Location__c,Location__r.Name, Visit_Date__c 
                FROM Location_Tracing__c WHERE Id=:locationTracingId 
                ORDER BY Visit_Date__c DESC];
    }
    
    /**
     * getVisitors of last 30 days based on locationId  
     * @param locationId
     * @return List<Location_Tracing__c>
    */
    public static List<Location_Tracing__c> getVisitorsOfLast30days(String locationId){
        return [SELECT Id, Name, Person__c,Person__r.Name,
                Person__r.Health_Status__c,Person__r.Token__c, 
                Location__c,Location__r.Name, Visit_Date__c 
                FROM Location_Tracing__c WHERE Location__c=:locationId AND Visit_Date__c=LAST_N_DAYS:30
                ORDER BY Visit_Date__c DESC];
    }
     /**
     * search locations based on personIds
     * @param personIds
     * @return List<Location_Tracing__c>
    */
    public static List<Location_Tracing__c> getLocationsByPersonIds(Set<Id> personIds){
        return [SELECT Id, Name, Person__c,Person__r.Name,
        Person__r.Health_Status__c,Person__r.Token__c, 
        Location__c,Location__r.Name, Visit_Date__c 
        FROM Location_Tracing__c WHERE Person__c IN :personIds 
        AND Visit_Date__c = LAST_N_DAYS:10  ];
    }
    
     /**
     * search locations based on locationIds
     * @param locationIds
     * @return List<Location_Tracing__c>
    */
    public static List<Location_Tracing__c> getLocationsByLocationIds(Set<Id> locationIds){
        return [SELECT Id, Name, Person__c,Person__r.Name,
        Person__r.Health_Status__c,Person__r.Token__c, 
        Location__c,Location__r.Name, Visit_Date__c 
        FROM Location_Tracing__c WHERE Location__c IN :locationIds 
        AND Person__r.Health_Status__c = 'green'
        AND Visit_Date__c = LAST_N_DAYS:10  ];
    }

    /**
     * search getLocationsTraces based on locationIds
     * @param locationIds
     * @return List<Location_Tracing__c>
    */
    public static List<Location_Tracing__c> getLocationsTraces(Set<Id> locationIds){
        return [SELECT Id,Person__c,Location__c
        FROM Location_Tracing__c WHERE Location__c IN :locationIds 
        AND Visit_Date__c = LAST_N_DAYS:10 AND 
        Person__r.Health_Status__c='Green'];
    }
    /** 
     * checkDuplicates
     * @param List<Location_Tracing__c>
     * @return List<Location_Tracing__c>
    */
    public static List<Location_Tracing__c> checkDuplicates(List<Location_Tracing__c> newLocationTraces){
      // store unique locationIds
      set<Id> locationIds=new Set<Id>();
      // store unique personIds
      set<Id> personIds=new Set<Id>();

      for(Location_Tracing__c trace : newLocationTraces){
        locationIds.add(trace.Location__c);
        personIds.add(trace.Person__c);
        }

      //map of existing records
      Map<Id,Set<Id>> mapOfExistingRecords=new Map<Id,Set<Id>>();

      // query existing records using locationIds and personIds
      List<Location_Tracing__c> listOfExistingRecords=[SELECT Id, Name, Person__c,Person__r.Name,
                                                       Person__r.Health_Status__c,Person__r.Token__c, 
                                                       Location__c,Location__r.Name, Visit_Date__c 
                                                       FROM Location_Tracing__c WHERE Location__c IN :locationIds 
                                                       AND Person__c IN :personIds 
        ];

        List<Location_Tracing__c> listOfDuplicates=new List<Location_Tracing__c>();

        if(listOfExistingRecords!=null && listOfExistingRecords.size()>0){
            for(Location_Tracing__c location:listOfExistingRecords){
                if(!mapOfExistingRecords.containsKey(location.Location__c)){
                    mapOfExistingRecords.put(location.Location__c, new Set<Id>());
                }
                // add persons to location
                // location1 : person1, person2,...etc.
                mapOfExistingRecords.get(location.Location__c).add(location.Person__c);
            }
        }
        // loop over new tracing records
        for(Location_Tracing__c newTrace:newLocationTraces){
            // first check for locationId
            // if item found in map, then check for person in set
            if(mapOfExistingRecords.containsKey(newTrace.Location__c) &&
            mapOfExistingRecords.get(newTrace.Location__c).contains(newTrace.Person__c)){
                listOfDuplicates.add(newTrace);
            }
        }
        return listOfDuplicates;

        /*
        Location_Tracing__c locationTracing1=new Location_Tracing__c(Person__c='a05dM000004DFGgQAO',Location__c='a03dM0000033q0JQAQ');
        Location_Tracing__c locationTracing2=new Location_Tracing__c(Person__c='a05dM000004DFGhQAO',Location__c='a03dM0000033qbRQAQ');
        Location_Tracing__c locationTracing3=new Location_Tracing__c(Person__c='a05dM000004DFGhQAO',Location__c='a03dM0000033q0JQAQ');
        List<Location_Tracing__c> newTraces=new List<Location_Tracing__c>();
        newTraces.add(locationTracing1);
        newTraces.add(locationTracing2);
        newTraces.add(locationTracing3);

        List<Location_Tracing__c> dup=CTLocationTracingController.checkDuplicates(newTraces);

        System.debug('list'+dup);

        System.debug('size'+dup.size());
*/
    }
}