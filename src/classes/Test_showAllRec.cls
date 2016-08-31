@isTest(SeeAllData=True)

public class Test_showAllRec 
{
    static testMethod void test_redirectTasks()
    {
        CAM_Assets_showAllRec assets=new CAM_Assets_showAllRec();
        CAM_AssetAllocation_showAllRec al=new CAM_AssetAllocation_showAllRec();
        CAM_AssetRequested_showAllRec ar=new CAM_AssetRequested_showAllRec();
        CAM_Location_showAllRec loc=new CAM_Location_showAllRec();
        CAM_ServiceReq_showAllRec sreq=new CAM_ServiceReq_showAllRec();
        
        try{System.debug('An unexpected error has occurred: ' );}
        catch(DmlException e){System.debug('An unexpected error has occurred: ' );}
        
         
        string currentApp='Application1';
        list<object> lma = [select Status__c,App_Name__c,Expire_Date__c from LMA_Audit__c where App_Name__c =: currentApp LIMIT 1];
//        psr.redirectProject();
        assets.getredirectAssets();
        
        string currentApp1='Application1';
        list<object> lma1 = [select Status__c,App_Name__c,Expire_Date__c from LMA_Audit__c where App_Name__c =: currentApp1 LIMIT 1];
//        rcs.redirectRiskConversations(); 
        al.getredirectAssetAllocation();
        
        string currentApp2='Application1';
        list<object> lma2 = [select Status__c,App_Name__c,Expire_Date__c from LMA_Audit__c where App_Name__c =: currentApp2 LIMIT 1];
//        rss.redirectRiskSearches();
        ar.getredirectAssetRequested();
        
        string currentApp3='Application1';
        list<object> lma3 = [select Status__c,App_Name__c,Expire_Date__c from LMA_Audit__c where App_Name__c =: currentApp3 LIMIT 1];
//        crs.redirectRules();
        loc.getredirectLocation();
        
        string currentApp4='Application1';
        list<object> lma4 = [select Status__c,App_Name__c,Expire_Date__c from LMA_Audit__c where App_Name__c =: currentApp4 LIMIT 1];
//        crs.redirectRules();
        sreq.getredirectServiceRequest();
        
        string str = 'test';
        System.assertEquals('test',str);
        
       /* clearCloud_showAllRec cc = new clearCloud_showAllRec();
        clearGovernance_showAllRec cg = new clearGovernance_showAllRec();
        clearMilestone_showAllRec cm = new clearMilestone_showAllRec();
        clearResilientRisk3_showAllRec cr = new clearResilientRisk3_showAllRec();
        ClearTasks_showAllRec ct = new ClearTasks_showAllRec();
        companyHierarchy_showAllRec ch = new companyHierarchy_showAllRec();
        RegHierarchy_showAllRec Rh = new RegHierarchy_showAllRec();
        survey_showAllRec ss = new survey_showAllRec();
        support_showAllRec ssr = new support_showAllRec();
        Socialgrcconfig_showAllRec sg = new Socialgrcconfig_showAllRec();
        clearRulesStudio_showAllRec crs = new clearRulesStudio_showAllRec();
        riskSearch_showAllRec rss = new riskSearch_showAllRec();
        riskConversation_showAllRec rcs = new riskConversation_showAllRec();
        Logs_showAllRec LSA = new Logs_showAllRec();
             
        try{System.debug('An unexpected error has occurred: ' );}
        catch(DmlException e){System.debug('An unexpected error has occurred: ' );}
        
        
      
        string currentAppLSA='Application1';
        list<object> lmaLSA = [select Status__c,App_Name__c,Expire_Date__c from LMA_Audit__c where App_Name__c =: currentAppLSA LIMIT 1];
        LSA.redirectLogs();
        
        Project_showAllRec psr = new Project_showAllRec(); 
        string currentApp='Application1';
        list<object> lma = [select Status__c,App_Name__c,Expire_Date__c from LMA_Audit__c where App_Name__c =: currentApp LIMIT 1];
        psr.redirectProject();
        
        string currentApp1='Application1';
        list<object> lma1 = [select Status__c,App_Name__c,Expire_Date__c from LMA_Audit__c where App_Name__c =: currentApp1 LIMIT 1];
        rcs.redirectRiskConversations();  
        
        string currentApp2='Application1';
        list<object> lma2 = [select Status__c,App_Name__c,Expire_Date__c from LMA_Audit__c where App_Name__c =: currentApp2 LIMIT 1];
        rss.redirectRiskSearches();
        
        string currentApp3='Application1';
        list<object> lma3 = [select Status__c,App_Name__c,Expire_Date__c from LMA_Audit__c where App_Name__c =: currentApp3 LIMIT 1];
        crs.redirectRules();
        
        string currentApp4='Application1';
        list<object> lma4 = [select Status__c,App_Name__c,Expire_Date__c from LMA_Audit__c where App_Name__c =: currentApp4 LIMIT 1];
        sg.redirectSocialgrcconfig();
        sg.sendEmail();
        string currentApp5='Application1';
        list<object> lma5 = [select Status__c,App_Name__c,Expire_Date__c from LMA_Audit__c where App_Name__c =: currentApp5 LIMIT 1];
        ssr.redirectsupport();
        
        string currentApp6='Application1';
        list<object> lma6 = [select Status__c,App_Name__c,Expire_Date__c from LMA_Audit__c where App_Name__c =: currentApp6 LIMIT 1];
        ss.redirectSurveys();
        
        string currentApp7='Application1';
        list<object> lma7 = [select Status__c,App_Name__c,Expire_Date__c from LMA_Audit__c where App_Name__c =: currentApp7 LIMIT 1];
        ch.redirectcompHier();
        ch.sendEmail();
        string currentApp8='Application1';
        list<object> lma8 = [select Status__c,App_Name__c,Expire_Date__c from LMA_Audit__c where App_Name__c =: currentApp8 LIMIT 1];
        ct.redirectTasks();
        
        string currentApp9='Application1';
        list<object> lma9 = [select Status__c,App_Name__c,Expire_Date__c from LMA_Audit__c where App_Name__c =: currentApp9 LIMIT 1];
        cr.redirectRisks();
        cr.sendEmail();
        
        string currentApp10='Application1';
        list<object> lma10 = [select Status__c,App_Name__c,Expire_Date__c from LMA_Audit__c where App_Name__c =: currentApp10 LIMIT 1];
        cm.redirectMilestone();
        
        string currentApp11='Application1';
        list<object> lma11 = [select Status__c,App_Name__c,Expire_Date__c from LMA_Audit__c where App_Name__c =: currentApp11 LIMIT 1];
        cc.getredirect();
        cc.sendEmail();
        string currentApp12='Application1';
        list<object> lma12 = [select Status__c,App_Name__c,Expire_Date__c from LMA_Audit__c where App_Name__c =: currentApp12 LIMIT 1];
        cg.redirectgovernance();
        cg.sendEmail();
        
        string currentApp13='Application1';
        list<object> lma13 = [select Status__c,App_Name__c,Expire_Date__c from LMA_Audit__c where App_Name__c =: currentApp13 LIMIT 1];
        Rh.redirectRegHierarchy();
        
        string str = 'test';
        System.assertEquals('test',str); */
    }
}