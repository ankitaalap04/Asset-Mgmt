/* Description: This class contains test methods to test Asset Assignment functionality */

@isTest
private class CAM_AssetAssignControllerTest
{
    /**
    *   Test Case:
    *   1) Create an instance of AM_AssetAssignController
    *   2) Check that the start date and end date are initialised
    *   3) Do not set required fields and check that the error message is thrown
    *   4) Create an allocation record successfully
    *   5) Try to allocate the same asset and check that an error is thrown
    */ 
    @isTest
    private static void testAssetAssignment()
    {
        /*Set up data*/
        //Create an instance of the AM_AssetAssignController
        List<AM_Asset__c> assets = CAM_TestUtilities.createTestAssets(3);
        ApexPages.StandardController sc = new ApexPages.StandardController(assets[0]);
        CAM_AssetAssignController assignController = new CAM_AssetAssignController(sc);
        List<ApexPages.Message> msg = assignController.errormessages;

        //Check that the dates are initialised
        system.assert(!String.isEmpty(assignController.allocationStartDateDisplay));
        system.assert(!String.isEmpty(assignController.allocationEndDate.format()));
       
        

        //Call createAllocation without setting any of the fields
        assignController.assetId=null;
        assignController.createAllocation();
        
        system.assert(CAM_TestUtilities.checkMessageExists(ApexPages.getMessages(),' field cannot be empty.'));

        //Create an available asset
        AM_Asset__c availableAsset = new AM_Asset__c();     
       // insert availableAsset;
        insert availableAsset;

        //Set the asset ID
        assignController.assetId = availableAsset.id;

        //Call createAllocation without setting Contact Id and Assign To Date
        assignController.createAllocation();
        system.assert(CAM_TestUtilities.checkMessageExists(ApexPages.getMessages(), 'Contact cannot be blank.'));

        //Create a contact
        Contact newContact = CAM_TestUtilities.createTestContacts(1)[0];

        //Set the contact ID
        assignController.contactId = newContact.Id;

        //Call createAllocation without setting Assign To Date
        assignController.allocationEndDate = null;
        assignController.createAllocation();
        system.assert(CAM_TestUtilities.checkMessageExists(ApexPages.getMessages(), 'Please enter Assign To date.'));

        //Reset the dates
        assignController.allocationStartDate = Datetime.now();
        assignController.allocationEndDate = assignController.allocationStartDate.addHours(1);

        //Call createAllocation after setting all values
        assignController.createAllocation();
        system.assert(assignController.allocationRecord!=null &&
                     !String.isEmpty(assignController.allocationRecord.id));
        
        
       // system.assert(CAM_TestUtilities.checkMessageExists(ApexPages.getMessages(), 'Error creating allocation. '));
     

        //Call createAllocation again and check that the asset cannot be assigned again
        assignController.assetId = availableAsset.id;
        assignController.contactId = newContact.Id;         
        assignController.createAllocation();
  //      system.assert(CAM_TestUtilities.checkMessageExists(ApexPages.getMessages(), 'Error creating allocation. '));
        system.assert(CAM_TestUtilities.checkMessageExists(ApexPages.getMessages(), 'The asset is already allocated for the specified dates. Please choose available dates or select a different asset.'));
   //     system.assert(CAM_TestUtilities.checkMessageExists(ApexPages.getMessages(), 'Error creating allocation. '));
    
        
        
        
        
        assignController.goHome();
        assignController.closeConfirmation();
        assignController.backMethod();
        
/*        //Ankita code
        ApexPages.Message[] pageMessages = ApexPages.getMessages();
        System.assertNotEquals(0, pageMessages.size());

        // Check that the error message you are expecting is in pageMessages
        Boolean messageFound = false;

        for(ApexPages.Message message : pageMessages) {
         if(message.getSummary() == 'Your summary'
           && message.getDetail() == 'Your detail'
           && message.getSeverity() == ApexPages.Severity.ERROR) {
        messageFound = true;        
         }
        }

        System.assert(messageFound); */
       }

}