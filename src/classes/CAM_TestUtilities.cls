/*   Utility test class to generate test data  */


@isTest
public class CAM_TestUtilities {

    //Assets
    public static List<AM_Asset__c> createTestAssets(Integer numAssets) {
        //Recordtypes
        List<RecordType> rtList= [select Id, 
                                         DeveloperName,
                                         Name 
                                  from RecordType
                                  where sObjectType =: CAM_Constants.AM_ASSET_API_NAME];                         

        List<AM_Asset__c> assetList = new List<AM_Asset__c>();
        for (Integer i=0; i<numAssets; i++) {
            assetList.add(new AM_Asset__c(AM_ID__c='TestAsset' + i, RecordTypeId = rtList[0].Id));
        }
        
        //insert assetList;
        //return assetList;
        try{
        insert assetList;
        }catch(DMLException e)
        {
            e.getMessage();
        }
           
        return assetList;
        
    } 

    //Contacts
    public static List<Contact> createTestContacts(Integer numContacts) {
        List<Contact> contactList = new List<Contact>();
        Account a = new Account(Name='TestAccount');
        insert a;
        for(Integer j=0;j<numContacts;j++) {
            contactList.add(new Contact(firstname='Test'+j,lastname='Test'+j,AccountId=a.Id));
        }
        insert contactList;     
        return contactList;
    }

    //Cases
    public static List<Service_Request__c> createTestCases(Integer numCases, AM_Asset__c asset) {
        List<Service_Request__c> cases = new List<Service_Request__c>();
        for (Integer i=0; i<numCases; i++) {
            cases.add(new Service_Request__c(AM_Asset__c=asset.Id, Mark_Asset_as_out_of_service__c=true, Subject__c='TestCase'+i));
        }
      //  insert cases;
      //  return cases;
        
        try{
        insert cases;
        }catch(DMLException e)
        {
            e.getMessage();
        }
           
        return cases;
    }

    //Allocations List
    public static List<AM_Asset_Allocation__c> createTestAllocations() {
        List<Contact> conList = createTestContacts(1);
        asset = new AM_Asset__c();
        //insert asset;
        try{
            insert asset;
        }catch(DMLException e)
        {e.getMessage();
        }

        List<AM_Asset_Allocation__c> allocList = new List<AM_Asset_Allocation__c>();
        allocList.add(new AM_Asset_Allocation__c(AM_Start_date__c = Date.today(), AM_End_date__c = Date.today() + 5, AM_Asset__c = asset.Id, AM_Contact__c = conList[0].Id));
      //  insert allocList;
      //  return allocList;
        
        try{
        insert allocList;
        }catch(DMLException e)
        {
            e.getMessage();
        }
           
        return allocList;
    }

    //Single Allocation
    public static AM_Asset_Allocation__c createTestAllocation(AM_Asset__c asset) {
        List<Contact> conList = createTestContacts(1);

        AM_Asset_Allocation__c newAlloc = new AM_Asset_Allocation__c(AM_Start_date__c = Date.today(), AM_End_date__c = Date.today() + 5, AM_Asset__c = asset.Id, AM_Contact__c = conList[0].Id);
        // insert newAlloc;
       // return newAlloc;
       try{
        insert newAlloc;
        }catch(DMLException e)
        {
            e.getMessage();
        }
           
        return newAlloc;
    }    
    
    public static AM_Asset__c asset {
        get; private set;
    }

    //Test User
    public static User createTestUser() {

         Profile p = [select id from profile where name='Standard User']; 

         User newUser = new User(alias = 'auser', 
                           email='assetuser@assetapp.com', 
                           emailencodingkey='UTF-8', 
                           lastname='Testing', 
                           languagelocalekey='en_US', 
                           localesidkey='en_US', 
                           profileid = p.Id, 
                           timezonesidkey='America/Los_Angeles',
                           username='assetuser@assetapp.com');

         insert newUser;
         return newUser;
    }

    //Method to check if a message exists
    public static Boolean checkMessageExists(List<ApexPages.Message> msgs, String msgText)
    {
        Boolean messageExists = false;
        for(Apexpages.Message msg:msgs){
            if (msg.getDetail().contains(msgText))
            {
                messageExists = true;
                break;
            } 
        }
        return messageExists;            
    }
    
    static testmethod void test1() {
        List<AM_Asset__c> assets = CAM_TestUtilities.createTestAssets(3);
        CAM_TestUtilities.createTestContacts(3);
        CAM_TestUtilities.createTestCases(3, assets[0]);    
        CAM_TestUtilities.createTestAllocations();    
    }
}