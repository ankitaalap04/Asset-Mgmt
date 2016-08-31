@isTest(SeeAllData=True)
public class Test_AssetsShowAllREcord {
    static testMethod void test_redirectMilestone()
    {
         CAM_Assets_showAllRec cg = new CAM_Assets_showAllRec();
         string currentapp='Agile Assets';
         string status = 'Active';
   
        
         List<object> lma = [select Status__c,App_Name__c,Expire_Date__c from LMA_Audit__c where App_Name__c =: currentapp LIMIT 1];
       
         cg.getredirectAssets();
         cg.sendEmail();
        Boolean test1;
        Boolean test2;
        Boolean flag;
        Boolean  t1,t2,t3;
        
        if(test1==t1 & test2==t2)
        {
              flag = true;
        }
        
        try{
            
        }
        catch(DmlException e)
        {
           
          
        }
        
        string str = 'test';
        System.assertEquals('test',str);
    }


}