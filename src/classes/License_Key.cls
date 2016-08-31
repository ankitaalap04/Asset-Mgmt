public class License_Key {
    
//List<Object> adminseats = new List<Object>();
///List<Object> csmseats = new List<Object>();
    
public string select_module {get; set;}
public String redirectFlag;

//-------------------------------------------ashok---------------------------------
public Task DateInput {get;set;}
public string No_Of_Seats {get;set;}
String OrgID = UserInfo.getOrganizationId();
String UserName = UserInfo.getUserName();
String UserGetName = UserInfo.getName();
String UserEmail = UserInfo.getUserEmail();
String UserLicense = UserInfo.getUserType();
public Boolean Perpetual {get;set;}
public String Licensekey{get;set;}
public string matchLicenseKeys{get;set;}

public String currentApp {get;private set;}

public page_access__c instanceUser, instancePro, instanceOrg; 

//String UID = UserInfo.getUserId();
 LMA_Audit__c lma = new LMA_Audit__c();
public License_Key()
{
   for(Schema.DescribeTabSetResult dtsr : Schema.describeTabs()) {
            if(dtsr.isSelected()) {
                currentApp = dtsr.label;
                System.debug('This is selectedapp: ' + currentApp);
              }
    } 
    instanceUser = page_access__c.getInstance(UserInfo.getOrganizationId());
   instancePro = page_access__c.getInstance(UserInfo.getProfileId());
   instanceOrg = page_access__c.getOrgDefaults();
     
}
    
 //--------------------------------------------ashok start------------------------------------
 public pagereference matchLicenseKeys()
    {
        System.debug('ashok in match key');
        redirectFlag = 'Denined'; 
        if(instanceOrg != NULL){
             List<LMA_Audit__c> auditlist =[select App_Name__c from LMA_Audit__c];
            integer i;
            List<String> tempList = new List<String>();
            for(LMA_Audit__c s : auditlist) {tempList.add(s.App_Name__c);}
            System.debug('lma object tempdata ' + tempList);
            for(i = 0;i<auditlist.size();i++)
            {
                if(tempList[i] == currentApp)
                {
                lma = [select License_Key__c,App_Name__c from LMA_Audit__c where App_Name__c =: currentApp LIMIT 1];
                  if(instanceOrg.License_Key__c == Licensekey && instanceOrg.Module_Name__c == currentApp)
                    { redirectFlag = 'Access'; system.debug('I am in NewOrg license condition');}
                  else if(lma.License_Key__c == Licensekey && lma.App_Name__c == currentApp)
                    { redirectFlag = 'Access'; system.debug('I am in sameOrg diff app license condition');}
              }
          } 
         }
       
        if(redirectFlag == 'Access')
        {
            try{
            lma = [select Status__c from LMA_Audit__c where App_Name__c =: currentApp LIMIT 1];
            lma.Status__c = 'Active';
            update lma;
            }catch(DmlException e) {
                System.debug('An unexpected error has occurred: ' + e.getMessage());}
           
             string surveyPrefix = '/apex/ClearGRCApps'; //Survey__c.sObjectType.getDescribe().getKeyPrefix();
             Pagereference p = new PageReference(surveyPrefix);//'/apex/ClearGRCApps');
             p.setRedirect(true);
             System.debug(' ashok key found...');
             return p;
        }else{
               Pagereference p = new PageReference('/apex/CG_Licensekey');
               p.setRedirect(true);
                System.debug('ashok key not found...');
               return p;
            }   
   }
    //----------------------------------------ashok end-------------------------------------- 
}