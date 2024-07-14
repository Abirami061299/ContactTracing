public with sharing class CTPeopleTracingDataCleanupBatch implements Database.Batchable<SObject> {


    public Database.QueryLocator start(Database.BatchableContext bc){
        String query='SELECT Id, Name, Contact_Date__c, Contact_Type__c, Person_1__c, Person_2__c FROM People_Tracing__c WHERE Contact_Date__c < LAST_N_DAYS:30';
        return Database.getQueryLocator(query);
   }

   public void execute(Database.BatchableContext bc, List<People_Tracing__c> scope){
         delete scope;
    }

 public void finish(Database.BatchableContext bc){
     System.debug('Batch Finished');
     // call another batch method
 }
  //create new instance
  // CTPeopleTracingDataCleanupBatch batchInstance = new CTPeopleTracingDataCleanupBatch();
  // Database.executeBatch(batchInstance,4);
}