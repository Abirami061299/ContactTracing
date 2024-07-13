public with sharing class CTHealthController {

    @AuraEnabled
    public static Map<String,Integer> getPersonHealthStatus(){
        try {
            return CTPersonController.getPersonHealthStatusCount();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Map<String,Integer> getLocationHealthStatus(){
        try {
            return CTLocationController.getLocationHealthStatusCount();

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}