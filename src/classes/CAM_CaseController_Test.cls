/* Description: Test class for the AM_CaseController */
@isTest
private class CAM_CaseController_Test {
    
    @isTest static void testCaseController1() {
        List<AM_Asset__c> assets = CAM_TestUtilities.createTestAssets(1);
        ApexPages.StandardController sc = new ApexPages.StandardController(assets[0]);
        CAM_CaseController con = new CAM_CaseController(sc);
        
        PageReference casePage = Page.CAM_CasePage;
        Test.setCurrentPage(casePage);
        
        con.assetName='test';
        System.assertEquals(con.assetName, 'test');
		//con.asset= 'Chair';
		con.attachmentName='test';
        System.assertEquals(con.attachmentName,'test');
        
        
        
        
        //Subject is empty
        con.createCase();
        System.assert(con.errormessages.size()>0);

        con.aCase.Subject__c = 'TestSubject';
        
        //Asset is empty
        con.aCase.AM_Asset__c = null;
        con.createCase();
        System.assert(con.errormessages.size()>0);
        
          con.aCase.AM_Asset__c = con.asset.id;
       //   con.aCase.AM_Asset__c= 'a0755000005IoU7';
        /* Ankita Code */
       // List<AM_Asset__c> TestAsset = new List<AM_Asset__c>{ }
         
        //Description is empty
        con.createCase();
        System.assert(ApexPages.hasMessages());
                
        con.aCase.Description__c = 'TestDescription';
        con.aCase.Mark_Asset_as_out_of_service__c = false;
        
        con.attach.body = Blob.valueOf('Unit Test Attachment Body');
        con.attach.Name = 'Test file name'; 
      
        con.createCase();
        
        Service_Request__c c = [select id, Subject__c from Service_Request__c where id =: con.newCaseId limit 1];
        Attachment a = [select id, Name from Attachment where parentId =: c.Id];
        System.AssertEquals(c.Subject__c, 'TestSubject');
        System.AssertEquals(a.Name, 'Test file name');
        System.assert(!con.showLookUp);
        
        //Try creating case with the same case ID
        con.aCase.Id = con.newCaseId;
        con.aCase.AM_Asset__c = assets[0].Id;
        con.aCase.Subject__c = 'TestSubject';
        con.aCase.Description__c = 'TestDescription';
                
        con.createCase(); 
        System.assert(ApexPages.hasMessages());
     
        System.assert(!con.showConfirmation);   
        
        con.backMethod();
        con.closeConfirmation();
        
        
    }
    
    @isTest static void testCaseController2() {
        List<Contact> contacts = CAM_TestUtilities.createTestContacts(1);

        ApexPages.StandardController sc = new ApexPages.StandardController(contacts[0]);
        CAM_CaseController con = new CAM_CaseController(sc);
        System.assert(ApexPages.hasMessages());       
 
    }

    @isTest static void testNoAttachment() {
        List<AM_Asset__c> assets = CAM_TestUtilities.createTestAssets(1);

        ApexPages.StandardController sc = new ApexPages.StandardController(assets[0]);
        CAM_CaseController con = new CAM_CaseController(sc);
        
        PageReference casePage = Page.CAM_CasePage;
        Test.setCurrentPage(casePage);
        
        con.aCase.Subject__c = 'TestSubject';     
        con.aCase.Description__c = 'TestDescription';
        con.aCase.Mark_Asset_as_out_of_service__c = false;
        
        con.createCase();
        
        Service_Request__c c = [select id, Subject__c from Service_Request__c where id =: con.newCaseId limit 1];
        System.AssertEquals(c.Subject__c, 'TestSubject');
        System.assert(con.showConfirmation);
        
        
        
        
    }            
}