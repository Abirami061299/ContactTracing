public with sharing class CTPersonStatusUpdateBatch implements Database.Batchable<SObject>{
   
    public Database.QueryLocator start(Database.BatchableContext bc){
        Date today=Date.today();
        Date fourteenDaysAgo=today-14;
        List<String> statuses=new List<String>{'Red','Yellow','Orange'};
        String query='SELECT Id,  Health_Status__c FROM Person__c WHERE Status_Update_Date__c < :fourteenDaysAgo AND Health_Status__c IN :statuses';
        return Database.getQueryLocator(query);
   }

   public void execute(Database.BatchableContext bc, List<Person__c> scope){
    for(Person__c personRecord : scope){
        personRecord.Health_Status__c='Green';
       }
      update scope;
    }

   public void finish(Database.BatchableContext bc){
     System.debug('Batch Finished');
    }
}