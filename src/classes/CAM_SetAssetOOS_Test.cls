/* Description: Test class for AM_SetAssetOOS_CaseTrigger */

@isTest
private class CAM_SetAssetOOS_Test {
    
  /*  @isTest static void testTrigger() {
        List<AM_Asset__c> assets = CAM_TestUtilities.createTestAssets(1);
        List<Case> cases = CAM_TestUtilities.createTestCases(1, assets[0]);
        Case aCase = cases[0];
        aCase.AM_Mark_Asset_as_out_of_service__c = true;
       // update aCase;
        try{
            update aCase;
        }catch(DMLException e)
        { e.getMessage();
        }
        
        AM_Asset__c myAsset = [select id, AM_Out_of_Service__c from AM_Asset__c where id =: aCase.AM_Asset__c];
        System.Assert(myAsset.AM_Out_of_service__c);
    } */
    
}