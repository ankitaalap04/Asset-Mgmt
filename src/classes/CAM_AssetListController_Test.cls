@isTest(SeeAllData=true)

private class CAM_AssetListController_Test {
    
    @isTest static void test_method_one() {
      
        List<AgileAssets__AM_Asset__c> assetList =CAM_TestUtilities.createTestAssets(3);
        
        CAM_AssetListController con = new CAM_AssetListController();
        PageReference assets = Page.CAM_AssetListPage;
//        con.filterFieldList = new List<schema.FieldSetMember>();
        String searchString = 'test';
        
        Test.setCurrentPage(assets);
        
        con.init();
        
        con.getFilterSection();
        con.initializeQuery();
        con.executeAssetQuery();
        
        con.assetStatus = '';
        con.executeAssetQuery();
        
        con.searchTerm = 'Available';
        con.executeAssetQuery();
        System.debug('ssc: ' + con.ssc.getRecords());
      
        
        List<ApexPages.Message> msg = con.errormessages;
        con.getAssetRecords();
        con.addStatusToQuery('test', true);
        
        List<RecordType> rtList= [select Id, 
                                         DeveloperName,
                                         Name 
                                  from RecordType
                                  where sObjectType =: CAM_Constants.AM_ASSET_API_NAME]; 
        
        ApexPages.currentPage().getParameters().put('recType', rtList[0].Id);
        con.initializeQuery();
        con.backMethod();
        con.assetStatus='Available';
            system.assertEquals('Available',con.assetStatus);
    }
        
    }