@isTest
private class CAM_LookUpComponentController_Test {
    
    @isTest static void assetLookupTest() {

        //Test Lookup for Assets
        List<RecordType> rtList= [select Id, 
                                         DeveloperName,
                                         Name 
                                  from RecordType
                                  where sObjectType =: CAM_Constants.AM_ASSET_API_NAME]; 

        List<AM_Asset__c> assets = CAM_TestUtilities.createTestAssets(3);
       

        CAM_LookUpComponentController con = new CAM_LookUpComponentController();
        list<ApexPages.Message> msg = con.compErrorMessages;
       
        apexpages.getMessages();
 //       list<Contact> cont=con.contactLookupValues;
        con.contactLookupValues = new list<Contact>();
        con.lookupObjectName = CAM_Constants.AM_ASSET_API_NAME;
        con.assetStatus = 'Available';
        con.lookupQuery = 'A-';
        con.assetRecordType = rtList[0].Id;
        con.runQuery();
        con.getcontactRecord();
        con.getAssets();
      
       
        con.assetRecordType = '';
       
        con.runQuery();
       

    }

    @isTest static void contactLookupTest() {
        CAM_LookUpComponentController con = new CAM_LookUpComponentController();
        CAM_TestUtilities.createTestContacts(3);
        con.lookupObjectName = CAM_Constants.AM_CONTACT_API_NAME;
        con.lookupQuery = 'Test';
        con.runQuery();

    }
    // Ankita test code
    @isTest Static void Testifelse()
    {
        CAM_LookUpComponentController con = new CAM_LookUpComponentController();
        CAM_TestUtilities.createTestContacts(3);
//        con.lookupObjectName = CAM_Constants.AM_CONTACT_API_NAME;
        con.lookupQuery='t';
        con.lookupObjectName='';

        
         List<ApexPages.Message> msg = con.compErrorMessages;
       
        con.runQuery();      
        system.assert(CAM_TestUtilities.checkMessageExists(ApexPages.getMessages(),'E3: Search term cannot be 1 character. Please change the search term.'));
//        con.runQuery();
//        system.assert(CAM_TestUtilities.checkMessageExists(ApexPages.getMessages(),'E4: LookUp object could not be determined. Please try again. If the error persists contact administrator'));
        
    }
    @isTest static void testtrycatch()
    {
        CAM_LookUpComponentController con = new CAM_LookUpComponentController();
        con.assetStatus='test';
        con.runQuery();
/*        try{
            con.runQuery();
        }
        catch(Exception e)
        {
          system.assert(CAM_TestUtilities.checkMessageExists(ApexPages.getMessages(),'E3: Error fetching Asset records. ( ' + e.getMessage() + ' )'));
 
        }*/
        
        	

    }
    
}