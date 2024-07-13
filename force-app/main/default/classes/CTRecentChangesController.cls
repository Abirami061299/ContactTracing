public with sharing class CTRecentChangesController {
    public CTRecentChangesController() {

    }

    @AuraEnabled
    public static List<Person__c> getRecentPersonHealthChanges(){
        try {
            return CTPersonController.getPersonRecords();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Location__c> getRecentLocationHealthChanges(){
        try {
            return CTLocationController.getLocationRecords();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Person__c> searchPeople(String searchTerm){
        try {
            return CTPersonController.searchRecords(searchTerm);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Location__c> searchLocation(String searchTerm){
        try {
            return CTLocationController.searchRecords(searchTerm);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
}