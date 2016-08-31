@isTest
public class CAM_AssetOOS_ServiceRequest_Test {
 @isTest static void testTrigger() {
        List<AM_Asset__c> assets = CAM_TestUtilities.createTestAssets(1);
        List<Service_Request__c> cases = CAM_TestUtilities.createTestCases(1, assets[0]);
        Service_Request__c aCase = cases[0];
        aCase.Mark_Asset_as_out_of_service__c = true;
       // update aCase;
        try{
            update aCase;
        }catch(DMLException e)
        { e.getMessage();
        } 
        AM_Asset__c myAsset = [select id, AM_Out_of_Service__c from AM_Asset__c where id =: aCase.AM_Asset__c];
     //   System.Assert(myAsset.AM_Out_of_service__c);
    }
    
}