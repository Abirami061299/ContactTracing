public with sharing class AccountContactService {
        public static void updateActiveContacts(Set<Id> accountIds){

            /* alternative solution
             List<Account> UpdatedAccounts = New List<Account>();
             For(Account result: [SELECT id, Active_Contacts__c,
                                 (SELECT Id from contacts where Active__c = True)
                                  FROM Account
                                 WHERE Id in:AccountIDs]){ 
 
            String AccountId = result.id;
            Integer ConCount = result.contacts.size();
            Account UpdatedAccount = New Account(Id = AccountId, Active_Contacts__c = ConCount);
            UpdatedAccounts.add(UpdatedAccount);
 
            }
            Update UpdatedAccounts;
             */
            List<AggregateResult> results =
            [SELECT  AccountId ,COUNT(Id) totalContacts FROM Contact 
            WHERE isActive__c=TRUE AND AccountId IN :accountIds  
            GROUP BY AccountId];

            Map<Id,Account> accountsToUpdate=new  Map<Id,Account>();
            for(AggregateResult result:results){
              String accId=String.valueOf(result.get('AccountId'));
              Integer totalContacts=Integer.valueOf(result.get('totalContacts'));
              Account acc= new Account(Id=accId,Active_Contacts__c=totalContacts);
              accountsToUpdate.put(accId,acc);
            }
            
            for(Id accId:accountIds){
              if((!accountsToUpdate.containsKey(accId))){
                 Account acc= new Account(Id=accId,Active_Contacts__c=0);
                 accountsToUpdate.put(accId,acc);
              }
            }
          update accountsToUpdate.values();
        }
}