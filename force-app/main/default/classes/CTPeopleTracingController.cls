public with sharing class CTPeopleTracingController {
    public CTPeopleTracingController() {

    }

     /**
     * getPeopleTraces based on personId
     * @param personId
     * @return List<People_Tracing__c>
    */
    public static List<People_Tracing__c> getPeopleTraces(String personId){
        return [SELECT Id,  Name, Person_1__c, Person_1__r.Name,Person_1__r.Health_Status__c,Person_1__r.Token__c ,
                Person_2__c,Person_2__r.Name,Person_2__r.Health_Status__c,Person_2__r.Token__c,
        	    Contact_Date__c, Contact_Type__c
                FROM People_Tracing__c WHERE Person_1__c=:personId OR Person_2__c=:personId
                ORDER BY Contact_Date__c DESC];
    }

    public static List<People_Tracing__c> checkDuplicates(List<People_Tracing__c> newPeopleTraces){

        // get unique person Ids
        Set<Id> personIds=new Set<Id>();
        for(People_Tracing__c peopleTrace:newPeopleTraces){
            personIds.add(peopleTrace.Person_1__c);
            personIds.add(peopleTrace.Person_2__c);

        }
        List<People_Tracing__c> listOfDuplicates=new List<People_Tracing__c>();
        Map<Id,Set<Id>> mapOfExistingRecords=new Map<Id,Set<Id>>();

        // query existing records using personIds
        List<People_Tracing__c> listOfExistingRecords=[SELECT Id,Person_1__c, Person_2__c
                                                       FROM People_Tracing__c WHERE Person_1__c IN :personIds 
                                                       OR Person_2__c IN :personIds 
                                                       ];

        if(listOfExistingRecords!=null && listOfExistingRecords.size()>0){
            for(People_Tracing__c peopleTrace:listOfExistingRecords){
                // build map for person 1

                if(!mapOfExistingRecords.containsKey(peopleTrace.Person_1__c)){
                    mapOfExistingRecords.put(peopleTrace.Person_1__c, new Set<Id>());
                }
                // add persons to persons Ids
                // person1 : person2, person3,...etc.

                mapOfExistingRecords.get(peopleTrace.Person_1__c).add(peopleTrace.Person_2__c);
                // build map for person 2
                if(!mapOfExistingRecords.containsKey(peopleTrace.Person_2__c)){
                    mapOfExistingRecords.put(peopleTrace.Person_2__c, new Set<Id>());
                }
                // add persons to persons Ids
                // person2 : person1, person3,...etc.

                mapOfExistingRecords.get(peopleTrace.Person_2__c).add(peopleTrace.Person_1__c);
            }
        }
        for(People_Tracing__c newPeopleTrace:newPeopleTraces){
            // first check for Person_1__c and Person_2__c
            // if item found in map, then check for person in set
            if(mapOfExistingRecords.containsKey(newPeopleTrace.Person_1__c) && mapOfExistingRecords.get(newPeopleTrace.Person_1__c).contains(newPeopleTrace.Person_2__c)
               || mapOfExistingRecords.containsKey(newPeopleTrace.Person_2__c) && mapOfExistingRecords.get(newPeopleTrace.Person_2__c).contains(newPeopleTrace.Person_1__c))
               {
                listOfDuplicates.add(newPeopleTrace);
            }
            
        }
        return listOfDuplicates;

    }
/*
Test cases
People_Tracing__c trace1=new People_Tracing__c(Person_1__c='a05dM000004DJvNQAW',Person_2__c='a05dM000004DKHxQAO');
People_Tracing__c trace2=new People_Tracing__c(Person_1__c='a05dM000004DFGgQAO',Person_2__c='a05dM000004DKHxQAO');
People_Tracing__c trace3=new People_Tracing__c(Person_1__c='a05dM000004DFGgQAO',Person_2__c='a05dM000004DKHxQAO');
List<People_Tracing__c> newTraces=new List<People_Tracing__c>();
newTraces.add(trace1);
newTraces.add(trace2);
newTraces.add(trace3);
List<People_Tracing__c> dup=CTPeopleTracingController.checkDuplicates(newTraces);
System.debug('list'+dup);
System.debug('size'+dup.size());
*/


}