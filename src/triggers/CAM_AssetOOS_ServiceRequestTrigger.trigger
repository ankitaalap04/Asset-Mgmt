trigger CAM_AssetOOS_ServiceRequestTrigger on Service_Request__c (after insert,after update) {
    List<Service_Request__c> cases = [Select Id, AM_Asset__c, Mark_Asset_as_out_of_service__c from Service_Request__c where Id IN: Trigger.new];
    List<Id> assetIdList = new List<Id>();
    List<AM_Asset__c> assetList = new List<AM_Asset__c>();

    For (Service_Request__c c : cases) {
        if (c.Mark_Asset_as_out_of_service__c == true) {
            assetIdList.add(c.AM_Asset__c);
        }
    }

    if (!assetIdList.isEmpty()) {
        AssetList = [Select Id, AM_Out_of_service__c from AM_Asset__c where Id IN: assetIdList];
        for (AM_Asset__c asset : assetList) {
            asset.AM_Out_of_service__c = true;
     //       asset.Available_for_allocation__c=false;
            
        }
        update assetList;
    }
}