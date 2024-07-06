public with sharing class CTPersonController {
    public CTPersonController() {

    }
    public static String  getToken(String phoneNumber){
        Blob value = Blob.valueOf(phoneNumber);
        Blob hash = Crypto.generateDigest('MD5', value);
        String token = EncodingUtil.base64Encode(hash);
        return token;
    }

    /**
     * Get 100 records with recent health changes
     * @return List<Person__c>
    */
    public static  List<Person__c> getPersonRecords(){
        return [SELECT Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c FROM Person__c ORDER BY Status_Update_Date__c DESC LIMIT 100];

    }

    /**
     * Search a person by  mobile,name,token
     * @return List<Person__c>
    */
    public static  List<Person__c> searchRecords(String searchTerm){
        searchTerm=searchTerm+'%';
        return [SELECT Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c FROM Person__c 
                WHERE Name LIKE :searchTerm OR 
                Token__C LIKE :searchTerm OR 
                Mobile__C LIKE :searchTerm 
                ORDER BY Status_Update_Date__c DESC NULLS LAST];

    }

     /**
     * Search a person by ID
     * @return Person__c
    */
    public static  Person__c getPersonById(String personId){
        List<Person__c> people = [SELECT Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c FROM Person__c 
                WHERE Id =:personId
                ];
        if(people!=null && people.size()>0){
            return people[0];
        }
        return null;

    }

     /**
     * Search count by healthStatus
     * @return Map<String,Integer>
    */
    public static  Map<String,Integer> getHealthStatusCount(){
        AggregateResult[] groupedResult= [SELECT Health_Status__c, COUNT(Id) total FROM Person__c 
                GROUP BY Health_Status__c
                ];
        Map<String,Integer> healthCountMap = new Map<String,Integer>();
        for(AggregateResult result:groupedResult){
            healthCountMap.put(String.valueOf(result.get('Health_Status__c')),Integer.valueOf(result.get('total')));
         }
        return healthCountMap;

    }
}