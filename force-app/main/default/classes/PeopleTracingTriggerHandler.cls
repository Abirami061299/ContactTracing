public with sharing class PeopleTracingTriggerHandler {
    public static void beforeInsertHandler(List<People_Tracing__c> newPeopleTraces){
       List<People_Tracing__c> duplicates=CTPeopleTracingController.checkDuplicates(newPeopleTraces);
       for(People_Tracing__c peopleTrace:duplicates){
        peopleTrace.addError('Duplicate record found Person1:'+peopleTrace.Person_1__c+'Person2'+peopleTrace.Person_2__c);
       }

    }
}