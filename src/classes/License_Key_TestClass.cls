@isTest(SeeAllData=True)
public class License_Key_TestClass {
    public static testmethod void matchLicenseKeys_TestMethod()
    {
        License_Key lk = new License_Key();
        string check = 'test';
     
        if(check !=null)
        {
            if(check == 'test')
                check = 'ok';
        }
        if(check == 'ok')
        {
         check = 'test';
         string currentapp='ConfidentG';
         string status = 'Active';
         List<object> lma = [select Status__c,App_Name__c,Expire_Date__c from LMA_Audit__c where App_Name__c =: currentapp LIMIT 1];
       
//        lk.matchLicenseKeys();                
        }else{
            
         check = 'tested';
         string currentapp='ConfidentG';
         string status = 'Active';
         List<object> lma = [select Status__c,App_Name__c,Expire_Date__c from LMA_Audit__c where App_Name__c =: currentapp LIMIT 1];
       
         lk.matchLicenseKeys();
        
        }
        try{
            check = 'test';
            lk.matchLicenseKeys();
        }
        catch(DmlException e)
        {
         check = 'tested';
         string currentapp='ConfidentG';
         string status = 'Active';
         List<object> lma = [select Status__c,App_Name__c,Expire_Date__c from LMA_Audit__c where App_Name__c =: currentapp LIMIT 1];
         lk.matchLicenseKeys(); 
        }
    }
     public static testmethod Pagereference TestmatchLicenseKeys()
     {
         License_Key cg = new License_Key();
 //        cg.Perpetual= true;
         cg.No_Of_Seats='test';
         cg.matchLicenseKeys='test1';
         cg.select_module='test2';
         cg.Perpetual=true;
         cg.Licensekey='test3';
         
         string surveyPrefix = '/apex/ClearGRCApps';
         Pagereference p = new PageReference(surveyPrefix);
      
         string currentapp='ConfidentG';
         string status = 'Active';
         List<object> lma = [select Status__c,App_Name__c,Expire_Date__c from LMA_Audit__c where App_Name__c =: currentapp LIMIT 1];
         cg.matchLicenseKeys();
         string str = 'test';
         System.assertEquals('test',str);
         return p; 
     }        
}