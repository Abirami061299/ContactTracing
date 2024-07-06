public with sharing class ContactTriggerHandler {
    public static void afterInsertHandler(List<Contact> newContacts){
        Set<Id> accountIds = new Set<Id>();

        for(Contact contact : newContacts) {
            if(String.isNotBlank(contact.AccountId)) {
                accountIds.add(contact.AccountId);
            }
        }
        AccountContactService.updateActiveContacts(accountIds);
    }
    
    public static void afterUpdateHandler(List<Contact> contactsToUpdate, Map<Id, Contact> oldContactsMap) {
        Set<Id> accountIds = new Set<Id>();

        for(Contact contact : contactsToUpdate) {
            if(String.isNotBlank(contact.AccountId) && oldContactsMap.get(contact.Id).isActive__c != contact.isActive__c) {
                accountIds.add(contact.AccountId);
            } else if(oldContactsMap.get(contact.Id).AccountId != contact.AccountId) {
                accountIds.add(contact.AccountId);
                accountIds.add(oldContactsMap.get(contact.Id).AccountId);
            }
        }
        AccountContactService.updateActiveContacts(accountIds);
    }
    
    public static void afterDeleteHandler(List<Contact> oldContacts) {
        Set<Id> accountIds = new Set<Id>();

        for(Contact contact : oldContacts) {
            if(String.isNotBlank(contact.AccountId)) {
                accountIds.add(contact.AccountId);
            }
        }
        AccountContactService.updateActiveContacts(accountIds);
    }
    
    public static void afterUndeleteHandler(List<Contact> recoveredContacts) {  // Fixed method name
        Set<Id> accountIds = new Set<Id>();

        for(Contact contact : recoveredContacts) {
            if(String.isNotBlank(contact.AccountId)) {
                accountIds.add(contact.AccountId);
            }
        }
        AccountContactService.updateActiveContacts(accountIds);
    }
}
