/*  Created Trigger to validate that asset allocation dates are available
*/

trigger CAM_ValidateDates_AllocationTrigger on AM_Asset_Allocation__c (before insert, before update) {
    List<Id> assetIdList = new List<Id>();
    for (AM_Asset_Allocation__c alloc : Trigger.New) {
        assetIdList.add(alloc.AM_Asset__c);
    }
    List<AM_Asset__c> assetList = [select Id from AM_Asset__c where Id IN : assetIdList];
    List<AM_Asset_Allocation__c> allocSiblings = [Select Id, AM_Start_date__c, AM_End_Date__c, AM_Asset__c from AM_Asset_Allocation__c where AM_Asset__c IN: assetList AND Id NOT IN: Trigger.New];
    System.debug('List of asset allocation siblings: ' + allocSiblings);

    for (AM_Asset_Allocation__c alloc : Trigger.New) {
        for (AM_Asset_Allocation__c sibling : allocSiblings) {
            if (alloc.AM_Start_date__c >= sibling.AM_Start_date__c && alloc.AM_End_Date__c <= sibling.AM_End_Date__c || 
                alloc.AM_Start_date__c <= sibling.AM_Start_date__c && alloc.AM_End_Date__c >= sibling.AM_End_Date__c ||
                alloc.AM_Start_date__c <= sibling.AM_Start_date__c && alloc.AM_End_Date__c <= sibling.AM_End_Date__c && alloc.AM_End_Date__c >= sibling.AM_Start_date__c ||
                alloc.AM_Start_date__c >= sibling.AM_Start_date__c && alloc.AM_End_Date__c >= sibling.AM_End_Date__c && alloc.AM_Start_date__c <= sibling.AM_End_Date__c) {
                alloc.addError('The asset is already allocated for the specified dates. Please choose available dates or select a different asset.');
            }
        }
    }


}