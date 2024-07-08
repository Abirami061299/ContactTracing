public with sharing class LocationTracingTriggerHandler {
    public static void beforeInsertHandler(List<Location_Tracing__c> newLocationTraces){
        List<Location_Tracing__c> duplicates=CTLocationTracingController.checkDuplicates(newLocationTraces);
        for(Location_Tracing__c locationTrace:duplicates){
            locationTrace.addError('Duplicate record found Person:'+locationTrace.Person__c+'Location'+locationTrace.Location__c);
        }
 
     }
}