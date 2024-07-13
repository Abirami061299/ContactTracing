public with sharing class CTLocationTabController {
    @AuraEnabled
    public static LocationInfo getLocationDetails(String recordId){
        try {
            LocationInfo info = new LocationInfo();
            Location__c  location = CTLocationController.getLocationById(recordId);
            if(location != null){
                info.name = location.Name;
                info.address = location.Address__c;
                info.pinCode = location.Pincode__c	;
                info.redScore = Integer.valueOf(location.Red_Score__c);
                info.statusUpdateOn = location.Status_Update_Date__c;
                info.status = location.Status__c;
             }
            List<Location_Tracing__c> locationTraces = CTLocationTracingController.getVisitorsOfLast30days(recordId);
            if(locationTraces != null && locationTraces.size() > 0){
                List <Contacts> closeContacts=new List<Contacts>();
                Set<Id> uniqueIds = new Set<Id>();
                uniqueIds.add(recordId);

                for(Location_Tracing__c trace:locationTraces){
                    Contacts cc=new Contacts();
                    if(!uniqueIds.contains(trace.Person__c)){
                        cc.id=trace.Person__c;
                        cc.status=trace.Person__r.Health_Status__c;
                        cc.token=trace.Person__r.Token__c;
                        cc.visitDate=trace.Visit_Date__c;
                        cc.name=trace.Person__r.Name;

                    }
                    closeContacts.add(cc);

                }
                info.contacts=closeContacts;
                info.contactsCount=closeContacts.size();
            }

            return info;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

    }

    public class LocationInfo{
        @AuraEnabled public String name;
        @AuraEnabled public String address;
        @AuraEnabled public String pinCode;
        @AuraEnabled public String status;
        @AuraEnabled public Integer redScore;
        @AuraEnabled public Date statusUpdateOn;
        @AuraEnabled public Integer contactsCount = 0;
        @AuraEnabled public List<Contacts> contacts;
    }

    public class Contacts{
        @AuraEnabled public String id;
        @AuraEnabled public String name;
        @AuraEnabled public String token;
        @AuraEnabled public String status;
        @AuraEnabled public Date visitDate;
    }
}