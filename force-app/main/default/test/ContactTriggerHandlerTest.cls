@isTest
public with sharing class ContactTriggerHandlerTest {
    @isTest
    public static void afterInsertHandlerTest(){

        List<Account> testAccounts=new List<Account>();
        testAccounts.add(new Account(Name='Test 1'));
        testAccounts.add(new Account(Name='Test 2'));

        insert testAccounts;

        List<Contact> testContacts = new List<Contact>();
        testContacts.add(new Contact(LastName='Test Contact 1',AccountId=testAccounts[0].Id));
        testContacts.add(new Contact(LastName='Test Contact 2',AccountId=testAccounts[0].Id));
        testContacts.add(new Contact(LastName='Test Contact 3',AccountId=testAccounts[0].Id));
        testContacts.add(new Contact(LastName='Test Contact 4',AccountId=testAccounts[0].Id));
        testContacts.add(new Contact(LastName='Test Contact 5',AccountId=testAccounts[1].Id));
        insert testContacts;

        List<Account> activeAccounts=[SELECT Id,Active_Contacts__c FROM Account];
        System.assertEquals(2,testAccounts.size());
        System.assertEquals(null,activeAccounts[0].Active_Contacts__c);
        System.assertEquals(null,activeAccounts[1].Active_Contacts__c);

        List<Contact> allContacts=[SELECT Id FROM Contact];
        System.assertEquals(5,allContacts.size());
       


    }

    @isTest
    public static void afterInsertHandlerTest2(){

        List<Account> testAccounts=new List<Account>();
        testAccounts.add(new Account(Name='Test 1'));
        testAccounts.add(new Account(Name='Test 2'));

        insert testAccounts;

        List<Contact> testContacts = new List<Contact>();
        testContacts.add(new Contact(LastName='Test Contact 1',AccountId=testAccounts[0].Id,isActive__c=true));
        testContacts.add(new Contact(LastName='Test Contact 2',AccountId=testAccounts[0].Id,isActive__c=true));
        testContacts.add(new Contact(LastName='Test Contact 3',AccountId=testAccounts[0].Id));
        testContacts.add(new Contact(LastName='Test Contact 4',AccountId=testAccounts[0].Id));
        testContacts.add(new Contact(LastName='Test Contact 5',AccountId=testAccounts[1].Id));
        insert testContacts;

        List<Account> accounts=[SELECT Id,Name,Active_Contacts__c FROM Account];
        System.assertEquals(2,testAccounts.size());
        for(Account account:accounts){
            if(account.Name=='Test 1'){
             System.assertEquals(2,account.Active_Contacts__c);
            }
           if(account.Name=='Test 2'){
              System.assertEquals(null,account.Active_Contacts__c);
            }
        }
        

        List<Contact> allContacts=[SELECT Id FROM Contact];
        System.assertEquals(5,allContacts.size());
       


    }
}