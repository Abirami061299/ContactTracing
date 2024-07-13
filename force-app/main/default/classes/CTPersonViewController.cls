public with sharing class CTPersonViewController {
    
    @AuraEnabled
    public static string updateHealthStatus(String personId){
        try {
            Person__c person = new Person__c(Id=personId);
            person.Health_Status__c='Red';
            update person;
            return 'Status updated to Green';
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}