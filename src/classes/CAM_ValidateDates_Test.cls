/*    Test class for the CAM_ValidateDates_AllocationTrigger */

@isTest
private class CAM_ValidateDates_Test {
    
    @isTest static void test_method_one() {
        CAM_TestUtilities.createTestAllocations();
        List<AM_Asset_Allocation__c> allocList = new List<AM_Asset_Allocation__c>();
        allocList.add(new AM_Asset_Allocation__c(AM_Asset__c = CAM_TestUtilities.asset.Id, AM_start_date__c = Date.Today(), AM_end_date__c = Date.Today()+1));
        try {
            insert allocList;
        } catch (DmlException ex) {
            System.assert(ex.getTypeName().contains('Dml'));
        }   
        
        
       
    }
    
}