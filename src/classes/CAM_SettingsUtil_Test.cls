@isTest
private class CAM_SettingsUtil_Test {
    
    @isTest static void test_method_one() {
        List<RecordType> rtList=new List<RecordType>();
            rtList=[select Id,DeveloperName,Name 
                                  from RecordType
                                  where sObjectType =: CAM_Constants.AM_ASSET_API_NAME]; 
        system.debug('test size'+rtList.size());
//		CAM_SettingsUtil con = new CAM_SettingsUtil();
        try{
                    CAM_SettingsUtil.setAssetLabel(rtList[0].Id);
        }
        catch(Exception e)
        {
        system.assert(CAM_TestUtilities.checkMessageExists(ApexPages.getMessages(),'I1: Could not fetch RecordType Name for' + rtList[0].Id + '. ( ' + e.getMessage() + ' )'));
        }
        CAM_SettingsUtil.setAssetRecordTypeId(rtList[0].Id);
        CAM_SettingsUtil.setAssetRecordTypeId('');
        
        
        
        
        List<ApexPages.Message> allMessages = new List<ApexPages.Message>();

        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'my error msg');
 //       ApexPages.Message myMsg= new ApexPages.addMessage(ApexPages.allMessages)
        
        allMessages.add(myMsg);
   
        
        CAM_SettingsUtil.prepareMessages(allMessages);
    } 
    
    @isTest static void test1()
    {
        String defaultRecordType = [select Id, AM_Asset_Record_Type__c 
                                        from User 
                                        where Id = :UserInfo.getUserId()
                                        Limit 1].AM_Asset_Record_Type__c;
        
  //      system.assert(CAM_TestUtilities.checkMessageExists(ApexPages.getMessages(),'E3: Please select an Asset Type in the Home page or contact administrator to set default asset type.'));
        

    }
}