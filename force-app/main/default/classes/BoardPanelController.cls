public with sharing class BoardPanelController {
    
    @AuraEnabled
    public static String addResult(String result,String mode){
        try {
            Word_Shuffle__c gameResult=new Word_Shuffle__c(Mode__c=mode,Result__c=result);
            insert gameResult;
            return 'Success';

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}