global with sharing class CAM_AssetAllocation_showAllRec
{

    public page_access__c instanceUser, instancePro, instanceOrg;  
    public String redirectFlag;
    public Date todayDate = date.today();
    public Integer days;
    LMA_Audit__c lma = new LMA_Audit__c();
    page_access__c pa = new page_access__c();
    public String currentApp {get;private set;}
  
    public PageReference getredirectAssetAllocation()
    {
    for(Schema.DescribeTabSetResult dtsr : Schema.describeTabs()) {
            if(dtsr.isSelected()) {
                currentApp = dtsr.label;
                System.debug('This is selectedapp: ' + currentApp);
               }
        }
    
     String uid = userInfo.getUserId();
        
        System.debug('This is User ID: ' + uid);
        //get users org.id
        instanceUser = page_access__c.getInstance(UserInfo.getOrganizationId());
        //  get users profile id
        instancePro = page_access__c.getInstance(UserInfo.getProfileId());
        // get user default org.
        instanceOrg = page_access__c.getOrgDefaults();
        
       // System.debug('This is User ID: ' + instanceUser.User_ID__c);
        //System.debug('This is test Detect User: ' + instanceUser);
        //System.debug('This is test Detect Pro: ' + instancePro);
        //System.debug('This is test Detect Org: ' + instanceOrg);
        redirectFlag = 'Denined';
         Messaging.SingleEmailMessage[] emails = new Messaging.SingleEmailMessage[] {};
       
             if(instanceOrg != NULL)
        {
            List<LMA_Audit__c> auditlist =[select App_Name__c from LMA_Audit__c];
            integer i;
            List<String> tempList = new List<String>();
            for(LMA_Audit__c s : auditlist) {tempList.add(s.App_Name__c);}
            System.debug('lma object tempdata ' + tempList);
            for(i = 0;i<auditlist.size();i++)
            {
              if(tempList[i] == currentApp)
                {
                    lma = [select Status__c,App_Name__c,Expire_Date__c from LMA_Audit__c where App_Name__c =: currentApp LIMIT 1];
                    if(lma.App_Name__c == currentApp && lma.Status__c == 'Active' && lma.Expire_Date__c > todayDate)
                    {
                        redirectFlag = 'Access';
                        days = todayDate.daysBetween(lma.Expire_Date__c);
                        if(days<=6 || days <=3)
                        {
                            system.debug('Your license will expire in 30 days...');
                            Messaging.SingleEmailMessage[] sent; 
                            Messaging.sendEmail(emails);
                            sent = emails;
                        }
                    }   
                }
            }
        }
     if(redirectFlag == 'Access')
        {
        String prefix = AM_Asset_Allocation__c.sObjectType.getDescribe().getKeyPrefix();
        Pagereference p = new PageReference('/'+prefix);
        p.setRedirect(true);
        return p;
   }
   else
   {
   Pagereference p = new PageReference('/apex/CG_Licensekey');
            p.setRedirect(true);
            System.debug('Ashok');
            return p;
   }
   
   /* String prefix = ClearCloud__c.sObjectType.getDescribe().getKeyPrefix();
        Pagereference p = new PageReference('/'+prefix);
        p.setRedirect(true);
        return p;*/
}
 
  public void sendEmail() {
               //   Messaging.sendEmail(emails);
              //     sent = emails;  Messaging.SingleEmailMessage[] emails
               Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    List<String> sendTo = new List<String>();
                    sendTo.add('devcg5@confidententerprise.com');
                    mail.setToAddresses(sendTo);
                    mail.setReplyTo('support@confidententerprise.com');
                    // Specify the name used as the display name.
                    mail.setSenderDisplayName('Confident Governance Support');
                    mail.setSubject('Please Renew ConfidentG Licenses Key');
                    String body = 'Dear ';// + UserGetName + , ';
                    //body += '<br>UserName: ' + UserName + '<br>Email: '+ UserEmail + ' <br>UserType: '+ UserLicense;
                    body += '<br><p>Thank you for being user of ConfidentG.<p/>';
                    body += '<br>We informing to you that '+days+ ' days remaining to expire license.';
                    body += '<br><p><b>License Management Team,</b></p>';
                    body += '<br><a href = "WWW.ConfidentGovernance.com">ConfidentGovernance.com</a><b>* Governance as a Service® Inventors</b>';
                    body += '<br><b>Global Leaders for Confident Governance, Security & Compliance for the Cloud and Enterprise</b>';
                    body += '<br><b>E-mail :</b><a href="mailto:support@confidentgovernance.com">support@confidentgovernance.com</a>';
                    body += '<br><b>INC. 5000 Award Winning Company * GEW50 Award Winner</b>';
                    body += '<br><b>Force.com Cloud Computing ISV Partner * SAP Solutions and Security Partner * Microsoft BizSparks Partner</b>';
                    body += '<br><a href="http://www.facebook.com/ConfidentGovernance">http://www.facebook.com/ConfidentGovernance</a>';
                    body += '<br><a href="http://www.linkedin.com/company/confident-governance">http://www.linkedin.com/company/confident-governance</a>';
                    body += '<br><a href="https://twitter.com/ClearGRC">https://twitter.com/ClearGRC</a>';
                    mail.setHtmlBody(body);
                    // Send the email you have created.
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}