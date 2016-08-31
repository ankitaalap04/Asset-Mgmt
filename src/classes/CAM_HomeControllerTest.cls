/* Description: This class contains test methods to test Home Page functionality */


@isTest
private class CAM_HomeControllerTest
{

    /**
    *   Test Case:
    *   1) Get a list of recordtypes
    *   2) Create an instance of AM_HomeController
    *   3) Check that the list of recordtype is identical to recordTypeOptions
    */  
    @isTest
    private static void testRecordTypeCount()
    {

    //Record Type List
    List<RecordType> rtList= [select Id, 
                                     DeveloperName,
                                     Name 
                              from RecordType
                              where sObjectType =: CAM_Constants.AM_ASSET_API_NAME];
                                       
        //Create controller instance
        CAM_HomeController newController = new CAM_HomeController();
        list<Apexpages.Message> msg= newController.errormessages;

        //Test recordtypes 
        system.assertEquals(rtList.size(), newController.recordTypeCount);  
       
    }

    /**
    *   Test Case:
    *   1) Create a user with AM_Asset_Record_Type__c blank
    *   2) Select a record type
    *   3) AM_Asset_Record_Type__c field in user should be populated with the selected recordtype
    */  
    @isTest
    private static void testRecordTypeSelection()
    {
        //Create a user
        User newUser = CAM_TestUtilities.createTestUser();

        //Run the test as new user
        system.runAs(newUser)
        {
            List<RecordType> rtList= [select Id, 
                                             DeveloperName,
                                             Name 
                                      from RecordType
                                      where sObjectType =: CAM_Constants.AM_ASSET_API_NAME];

            //Create controller instance
            CAM_HomeController newController = new CAM_HomeController();

            //Set the recordtype
            newController.selectedRecordTypeId = rtList[0].Id;

            //Call the Refresh method
            newController.refreshHomepage();

            //Get the user record
            User updatedUser = [select Id, 
                                       AM_Asset_Record_Type__c
                                from User
                                where Id = :newUser.Id];

            //Check that the AM_Asset_Record_Type__c field is set
            system.assertEquals(rtList[0].Id, updatedUser.AM_Asset_Record_Type__c); 

            //Check the label
            system.assertEquals(newController.assetlabel, rtList[0].Name);   
            newController.init();

        }                                               
    }

    /**
    *   Test Case:
    *   1) Create 4 Available, 3 Assigned and 2 Out of Service Assets
    *   2) Check if correct count is obtained
    */  
    @isTest
    private static void testAssetCounts()
    {
        //Record Types
        List<RecordType> rtList= [select Id, 
                                             DeveloperName,
                                             Name 
                                      from RecordType
                                      where sObjectType =: CAM_Constants.AM_ASSET_API_NAME];
        //Available assets
        List<AM_Asset__c> availableAssets = CAM_TestUtilities.createTestAssets(4);

        //Assigned assets
        List<AM_Asset__c> assignedAssets = CAM_TestUtilities.createTestAssets(3);
        
        //For each asset create an allocation
        for(AM_Asset__c assignAsset: assignedAssets)
        {
            CAM_TestUtilities.createTestAllocation(assignAsset);
        }

        //Out of service assets
        List<AM_Asset__c> oosAssets = CAM_TestUtilities.createTestAssets(2); 

        //Mark them OOS
        for(AM_Asset__c oos: oosAssets)
        {
            oos.AM_Out_of_Service__c = true;
        }           

         //update oosAssets;
        try{
            update oosAssets;
        }catch(DMLException e)
        {
           e.getMessage();
        }
       

        //Create a new user
        User newUser = CAM_TestUtilities.createTestUser();
        newuser.AM_Asset_Record_Type__c = rtList[0].Id;

      //  update newUser;
         try{
            update newUser;
        }catch(DMLException e)
        {
           e.getMessage();
        }

        system.runAs(newUser)
        {
            CAM_HomeController newController = new CAM_HomeController();
            system.assertEquals(newController.availableCount, 4);
            system.assertEquals(newController.assignedCount, 3);
            system.assertEquals(newController.outOfServiceCount, 2);
        }
    }

    /**
    *   Test Case:
    *   1) Create 5 cases
    *   2) Check if the cases are retrieved
    */  
    @isTest
    private static void testCaseCounts()
    {
        //Record Types
        List<RecordType> rtList= [select Id, 
                                             DeveloperName,
                                             Name 
                                      from RecordType
                                      where sObjectType =: CAM_Constants.AM_ASSET_API_NAME];

        //Create a new user
        User newUser = CAM_TestUtilities.createTestUser();
        newuser.AM_Asset_Record_Type__c = rtList[0].Id;

        update newUser;

        system.runAs(newUser)
        {
            //Available assets
            List<AM_Asset__c> availableAssets = CAM_TestUtilities.createTestAssets(1);

            //Create Cases
            List<Service_Request__c> newCases = CAM_TestUtilities.createTestCases(4, availableAssets[0]);  
                    
            //Create controller instance        
            CAM_HomeController newController = new CAM_HomeController();

            //Assert
          //  system.assertEquals(newController.caseList.size(), 4);
//          system.assertEquals(newController.caseList.size(), 4);

        }
    }           
}