@istest(SeeAllData=true)

public class SecureSettingsController_TestMethod
{
    
    static TestMethod void SecureSettingsController_TestMethod()
    {
    integer i;
        String Licensekey='test';
        String select_Lictype='EL';
    SecureSettingsController sc = new SecureSettingsController();
    sc.GenerateLicenseKeys();
        
    sc.LicInfo();
    sc.getLicenses();
    sc.LicenseType();
    sc.getobjNames();
    sc.getTabName();
    sc.getTabName1();
    sc.onUserChange();
    sc.onProfileChange();
  //  system.assert(sc.select_LicType==select_Lictype);
        
        
  
       // page_access__c pc1 = new page_access__c(name='package');
       // insert pc1;
       // ID profile= [Select Id from Profile Where Profile.Name =: 'System Administrator'].ID;
      //  page_access__c pc = new page_access__c(name ='profile');
      //  insert pc;
        
/*    string data = 'check';
    string data1 = 'test';
        try{
        if(data == 'check')
        {
            page_access__c paa = new  page_access__c();
             LMA_Audit__c lma = new LMA_Audit__c(
                   License_Key__c = 'keytesting',
                          License_Type__c = 'IL',
                          Expire_Date__c = date.today() ,
                          User_ID__c = UserInfo.getUserId(),
                          Contact__c = '01',
                          Install_Date__c = date.today(),
                          No_of_Seats__c = 5,
                          Package_Version__c = 'v4.1',
                          Subscriber_Org_Id__c = UserInfo.getOrganizationId(),
                          App_Name__c = 'ConfidentG',
                          Status__c = 'Inactive');
                  insert lma;
            if(data1 == 'test')
            {
                data = 'check ok';                 
            }
            else
            {
                data1 = 'test ok';
                data = null;
            }
        }
        if(data1 == 'test')
        {
                 
        }
        }catch(Exception e){system.debug(e.getMessage());}
        */
    sc.test ();        
  
    }          

}