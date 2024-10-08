public with sharing class CTPersonController {
    public CTPersonController() {

    }
    public static String  getToken(String phoneNumber){
        Blob value = Blob.valueOf(phoneNumber);
        Blob hash = Crypto.generateDigest('MD5', value);
        String token = EncodingUtil.base64Encode(hash);
        return token;
    }

    /**
     * Get 100 records with recent health changes
     * @return List<Person__c>
    */
    public static  List<Person__c> getPersonRecords(){
        return [SELECT Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c FROM Person__c ORDER BY Status_Update_Date__c DESC LIMIT 100];

    }

    /**
     * Search a person by  mobile,name,token
     * @return List<Person__c>
    */
    public static  List<Person__c> searchRecords(String searchTerm){
        searchTerm=searchTerm+'%';
        return [SELECT Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c FROM Person__c 
                WHERE Name LIKE :searchTerm OR 
                Token__C LIKE :searchTerm OR 
                Mobile__C LIKE :searchTerm 
                ORDER BY Status_Update_Date__c DESC NULLS LAST];

    }

     /**
     * Search a person by ID
     * @return Person__c
    */
    public static  Person__c getPersonById(String personId){
        List<Person__c> people = [SELECT Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c FROM Person__c 
                WHERE Id =:personId
                ];
        if(people!=null && people.size()>0){
            return people[0];
        }
        return null;

    }

     /**
     * Search count by healthStatus
     * @return Map<String,Integer>
    */
    public static  Map<String,Integer> getHealthStatusCount(){
        AggregateResult[] groupedResult= [SELECT Health_Status__c, COUNT(Id) total FROM Person__c 
                GROUP BY Health_Status__c
                ];
        Map<String,Integer> healthCountMap = new Map<String,Integer>();
        for(AggregateResult result:groupedResult){
            healthCountMap.put(String.valueOf(result.get('Health_Status__c')),Integer.valueOf(result.get('total')));
         }
        return healthCountMap;

    }

     /**
     * get cohabitants
     * @param Set<Id> personIds
     * @return Set<Id>
    */
    public static  Set<Id> getCohabitants(Set<Id> personIds,Set<Id> alreadyProcessed){
        Set<Id> cohabitants=new Set<Id>();
        List<String> healthStatuses=new List<String>{'Green','Yellow'};
        List<People_Tracing__c> peopleTraces=[SELECT Id, Contact_Type__c, Person_1__c, Person_2__c 
                                              FROM People_Tracing__c WHERE (Person_1__c in:personIds OR Person_2__c in:personIds) 
                                              AND Contact_Type__c='Cohabitant' AND 
                                              (Person_1__r.Health_Status__c in:healthStatuses 
                                              OR Person_2__r.Health_Status__c in:healthStatuses)
                                              ];
        for(People_Tracing__c trace:peopleTraces){
            if(!alreadyProcessed.contains(trace.Person_1__c)){
                cohabitants.add(trace.Person_1__c);
                alreadyProcessed.add(trace.Person_1__c);
            }
            if(!alreadyProcessed.contains(trace.Person_2__c)){
                cohabitants.add(trace.Person_2__c);
                alreadyProcessed.add(trace.Person_2__c);

            }
        }
        return cohabitants;

    }

    /**
     * get neighbors
     * @param Set<Id> personIds
     * @return Set<Id>
    */
    public static  Set<Id> getNeighbors(Set<Id> personIds,Set<Id> alreadyProcessed){
        Set<Id> neighbors=new Set<Id>();
        List<People_Tracing__c> peopleTraces=[SELECT Id, Contact_Type__c, Person_1__c, Person_2__c 
                                              FROM People_Tracing__c WHERE (Person_1__c in:personIds OR Person_2__c in:personIds) 
                                              AND Contact_Type__c='Neighbour' AND 
                                              (Person_1__r.Health_Status__c ='Green' 
                                              OR Person_2__r.Health_Status__c  ='Green')
                                              ];
        for(People_Tracing__c trace:peopleTraces){
            if(!alreadyProcessed.contains(trace.Person_1__c)){
                neighbors.add(trace.Person_1__c);
                alreadyProcessed.add(trace.Person_1__c);

            }
            if(!alreadyProcessed.contains(trace.Person_2__c)){
                neighbors.add(trace.Person_2__c);
                alreadyProcessed.add(trace.Person_2__c);

            }
        }
        return neighbors;

    }

    /**
     * get primary contacts
     * @param Set<Id> personIds
     * @return Set<Id>
    */
    public static  Set<Id> getPrimaryContacts(Set<Id> personIds,Set<Id> alreadyProcessed){
        Set<Id> primaryContacts=new Set<Id>();
        List<String> healthStatuses=new List<String>{'Green','Yellow'};

        List<People_Tracing__c> peopleTraces=[SELECT Id, Contact_Type__c, Person_1__c, Person_2__c 
                                              FROM People_Tracing__c WHERE (Person_1__c in:personIds OR Person_2__c in:personIds) 
                                              AND Contact_Type__c='Other' AND 
                                              Contact_Date__c	= LAST_N_DAYS:10 AND
                                              (Person_1__r.Health_Status__c in:healthStatuses 
                                              OR Person_2__r.Health_Status__c  in:healthStatuses )
                                              ];
        for(People_Tracing__c trace:peopleTraces){
            if(!alreadyProcessed.contains(trace.Person_1__c)){
                primaryContacts.add(trace.Person_1__c);
                alreadyProcessed.add(trace.Person_1__c);

            }
            if(!alreadyProcessed.contains(trace.Person_2__c)){
                primaryContacts.add(trace.Person_2__c);
                alreadyProcessed.add(trace.Person_2__c);

            }
        }
        return primaryContacts;

    }

     /**
     * get secondary contacts
     * @param Set<Id> personIds
     * @return Set<Id>
    */
    public static  Set<Id> getSecondaryContacts(Set<Id> primaryContactsIds,Set<Id> alreadyProcessed){
        Set<Id> secondaryContacts=new Set<Id>();
        List<String> healthStatuses=new List<String>{'Green','Yellow'};

        List<People_Tracing__c> peopleTraces=[SELECT Id, Contact_Type__c, Person_1__c, Person_2__c 
                                              FROM People_Tracing__c WHERE (Person_1__c in:primaryContactsIds OR Person_2__c in:primaryContactsIds) 
                                              AND Contact_Type__c='Other' AND 
                                              Contact_Date__c	= LAST_N_DAYS:10 AND
                                              (Person_1__r.Health_Status__c in:healthStatuses 
                                              OR Person_2__r.Health_Status__c  in:healthStatuses )
                                              ];
        for(People_Tracing__c trace:peopleTraces){
            if(!alreadyProcessed.contains(trace.Person_1__c)){
                secondaryContacts.add(trace.Person_1__c);
                alreadyProcessed.add(trace.Person_1__c);

            }
            if(!alreadyProcessed.contains(trace.Person_2__c)){
                secondaryContacts.add(trace.Person_2__c);
                alreadyProcessed.add(trace.Person_2__c);

            }
        }
        return secondaryContacts;

    }

    public static Map<String,Integer> getPersonHealthStatusCount(){
        AggregateResult[] healthCount = [SELECT  Health_Status__c, COUNT(Id) total FROM Person__c GROUP BY Health_Status__c];
        if(healthCount!=null && healthCount.size()>0){
            Map<String,Integer> healthCountMap=new Map<String,Integer>();
            for(AggregateResult ar:healthCount){
                 healthCountMap.put(String.valueOf(ar.get('Health_Status__c')),Integer.valueOf(ar.get('total')));
            }
            return healthCountMap;
        }
        return null;
    }
}