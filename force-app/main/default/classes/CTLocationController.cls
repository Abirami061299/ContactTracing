public with sharing class CTLocationController {
    public CTLocationController() {

    }


    /**
     * Get 100 records with recent health changes
     * @return List<Location__c>
    */
    public static  List<Location__c> getLocationRecords(){
        return [SELECT Id, Name,Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c FROM Location__c	ORDER BY Status_Update_Date__c DESC NULLS LAST LIMIT 100];

    }

    /**
     * Search a location by name,pincode,address
     * @return List<Location__c>
    */
    public static  List<Location__c> searchRecords(String searchTerm){
        searchTerm=searchTerm+'%';
        return [SELECT Id, Name,Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c FROM Location__c
                WHERE Name LIKE :searchTerm OR 
                Pincode__c LIKE :searchTerm OR 
                Address__c LIKE :searchTerm 
                ORDER BY Status_Update_Date__c DESC NULLS LAST];

    }

     /**
     * Search a location by ID
     * @return Location__c	
    */
    public static  Location__c	 getLocationById(String locationId){
        List<Location__c> location = [SELECT Id, Name,Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c FROM Location__c 
                WHERE Id =:locationId
                ];
        if(location!=null && location.size()>0){
            return location[0];
        }
        return null;

    }

       /**
     * Search count by healthStatus
     * @return Map<String,Integer>
    */
    public static  Map<String,Integer> getHealthStatusCount(){
        AggregateResult[] groupedResult= [SELECT Status__c, COUNT(Id) total FROM Location__c 
                GROUP BY Status__c
                ];
        Map<String,Integer> healthCountMap = new Map<String,Integer>();
        for(AggregateResult result:groupedResult){
            healthCountMap.put(String.valueOf(result.get('Status__c')),Integer.valueOf(result.get('total')));
         }
        return healthCountMap;

    }
}