public with sharing class SecureSettingsController {
    
public List<user> userTemp = new List<user>();
    
public List<profile> profileTemp = new List<profile>();
    
public string SelectedUser {get; set;}
    
public string SelectedProfile {get; set;}

public string select_LicType {get; set;}
    
public list<listTab> LT {get; set;}
    
public list<tablist_IL> ns  {get; set;}
    
List<String> select_tablist = new list<String>();
    
List<String> Modlist = new list<String>();

//------ashok------
public Task DateInput {get;set;}
public integer No_Of_Seats {get;set;}
public Boolean Perpetual {get;set;}
public String Licensekey{get;set;}
//public integer Lic_No = 0000;
public string select_module {get; set;}
    
public page_access__c instanceUser, instancePro, instanceOrg; 
LMA_Audit__c lmaseat = new LMA_Audit__c(); 

String OrgID = UserInfo.getOrganizationId();
String OrgName = UserInfo.getOrganizationName();
String UID = UserInfo.getUserId();
String UserName = UserInfo.getUserName();
String UserGetName = UserInfo.getName();
String UserEmail = UserInfo.getUserEmail();    
String UserLicense = UserInfo.getUserType();    
Date nextExpiryDate = date.today();  
Date LMAExpiryDate;
public String currentApp {get;private set;}
    
public SecureSettingsController()
{
    system.debug('PiyushUserLicense');
    
  getobjNames();
  getTabName();
 // getLicenses();
  DateInput = new Task();
     for(Schema.DescribeTabSetResult dtsr : Schema.describeTabs()) {
            if(dtsr.isSelected()) {
                currentApp = dtsr.label;
                System.debug('This is selectedapp: ' + currentApp);
                
              //  Pagereference p = new PageReference('/apex/CG_Licensekey');
              //  p.setRedirect(true);
            }
     }
     select_LicType = 'EL'; //Only for enterprise license picklist removed
}
    //--------ashok--------
 /* public void save() {
    Date dInputDate = DateInput.ActivityDate;
    //Format Date
    DateTime dtValue = DateTime.newInstance(dInputDate.year(), dInputDate.month(), dInputDate.day());
    string sFormattedDate = dtValue.format('yyyy-MM-dd');
    }
 */

  public void LicInfo()
 {
      instanceUser = page_access__c.getInstance(UserInfo.getOrganizationId());
      instancePro = page_access__c.getInstance(UserInfo.getProfileId());
      instanceOrg = page_access__c.getOrgDefaults(); 
  
     LMA_Audit__c lma1 = new LMA_Audit__c();
   
     
     if(select_LicType =='IL')
     {
     system.debug('Nikunj_ inside Individual License  && selected Records are : '+ns.size() );
   
         for(tablist_IL L : ns)
         {  //-------------------------------Ashok start--------------------
             if(l.selected==True)
             {
                 System.debug('License Type : '+select_LicType+' Selected Module is : '+select_module+' Expire Date : '+DateInput.ActivityDate +' Selected User : ' + SelectedUser+'Selected Tab is  : '+ l.tab+' Read Only Permission : '+l.ReadOnly);
                 instanceUser.License_Key__c = Licensekey; // 'mindit';
                 instanceUser.License_Type__c = select_LicType;
                 instanceUser.Expire_date__c = DateInput.ActivityDate;
                 instanceUser.Perpetual__c = Perpetual;
                 instanceUser.License_no__c = No_Of_Seats;
                 instanceUser.Tabs__c = l.tab;
                 instanceUser.Org_ID__c = OrgID;
               //  pa.SetupOwnerId = UID;
                // Lic_No = Lic_No + 1;
              
             }            
         }
     }
     else if(select_LicType =='EL' )
     {  
     string temp=null;
     //system.debug('Piyush Enterprise License  ');
     system.debug('License Type : '+ select_LicType +' Selected Module is : '+select_module +' Expire Date : '+DateInput.ActivityDate+' No of Sheet : '+No_Of_Seats +' List Of Tab: ' +select_tablist);
   
         // ashok validation before enter new license key---------------------------------------------------
        
        for(string str : select_tablist)
        {
            temp=temp+str+', ';
        }
         try{
                    if(instanceOrg.Org_ID__c != OrgID )
                    {
                        page_access__c paa = new  page_access__c(); 
                       // Application__c appcs = new Application__c();
                        paa.License_Key__c = Licensekey;
                        paa.License_Type__c = select_LicType;
                        paa.Module_Name__c=select_module;
                        
                         if(Perpetual == TRUE)
                            {
                                paa.Expire_date__c = nextExpiryDate.addYears(99);
                            }
                        else
                            {
                                paa.Expire_date__c = DateInput.ActivityDate;
                            }
                        //paa.Expire_date__c = DateInput.ActivityDate;
                        paa.Perpetual__c = Perpetual;
                        paa.License_no__c = No_Of_Seats;
                        paa.Org_ID__c = OrgID;
                        paa.User_ID__c = UID;
                        paa.Tabs__c=temp;
                      //    insert new Application__c(Name=select_module);
                        system.debug('ashok in try ');
                        insert paa; 
                          LMA_Audit__c lma = new LMA_Audit__c(
                          License_Key__c = Licensekey,
                          License_Type__c = select_LicType,
                          Expire_Date__c =  paa.Expire_date__c,//DateInput.ActivityDate,
                          Perpetual__c = String.valueOf(Perpetual),
                          User_ID__c = UID,
                          Contact__c = '+919979929941',
                          Install_Date__c = date.today(),
                          No_of_Seats__c = No_Of_Seats,
                          Package_Version__c = String.valueOf(System.requestVersion().major()),
                          Subscriber_Org_Id__c = OrgID,
                          App_Name__c = select_module,
                          Status__c = 'Inactive'
                         );
                        system.debug('ashok lma key '+ lma.License_Key__c);
                        insert lma;
                        system.debug('ashok lma ID '+ lma.Id);
                        }                      
                    if(instanceOrg.Org_ID__c == OrgID && lmaseat.App_Name__c != select_module)
                    {
                       /*   page_access__c paa = new  page_access__c();          
                        paa.License_Key__c = Licensekey;
                        paa.License_Type__c = select_LicType;
                        paa.Module_Name__c=select_module;
                        
                         if(Perpetual == TRUE)
                            {
                                paa.Expire_date__c = date.today();
                            }
                        else
                            {
                                paa.Expire_date__c = DateInput.ActivityDate;
                            }
                        //paa.Expire_date__c = DateInput.ActivityDate;
                        paa.Perpetual__c = Perpetual;
                        paa.License_no__c = No_Of_Seats;
                        paa.Org_ID__c = OrgID;
                        paa.User_ID__c = UID;
                        paa.Tabs__c=temp;
                        system.debug('ashok in try ');
                        insert paa; */
                         if(Perpetual == TRUE)
                            {
                                LMAExpiryDate = nextExpiryDate.addYears(99);
                            }
                          else
                            {
                                LMAExpiryDate = DateInput.ActivityDate;
                            }
                          LMA_Audit__c lma = new LMA_Audit__c(
                          License_Key__c = Licensekey,
                          License_Type__c = select_LicType,
                          Expire_Date__c =  LMAExpiryDate,
                          User_ID__c = UID,
                          Contact__c = '+919979929941',
                          Install_Date__c = date.today(),
                          No_of_Seats__c = No_Of_Seats,
                          Package_Version__c = String.valueOf(System.requestVersion().major()),
                          Subscriber_Org_Id__c = OrgID,
                          App_Name__c = select_module,
                          Status__c = 'Inactive'
                          
                         );
                      //  insert new Application__c(Name=select_module);
                        system.debug('ashok lma key '+ lma.License_Key__c);
                        insert lma;
                        system.debug('ashok lma ID '+ lma.Id);
                        }                      
                    
                /*  else if(instanceOrg.User_ID__c != UID && lmaseat.App_Name__c != select_module)
                    {
                                   
                            page_access__c paa = new  page_access__c(SetupOwnerId = UID, Name = OrgName);          
                            paa.License_Key__c = Licensekey;
                            paa.License_Type__c = select_LicType;
                            paa.Module_Name__c=select_module;
                            
                            if(Perpetual == TRUE)
                            {
                                paa.Expire_date__c = date.today();
                            }
                            else
                            {
                                paa.Expire_date__c = DateInput.ActivityDate;
                            }
                            
                        paa.Perpetual__c = Perpetual;
                        paa.License_no__c = No_Of_Seats;
                        paa.Org_ID__c = OrgID;
                        paa.User_ID__c = UID;
                        paa.Tabs__c=temp;
                        system.debug('piyush with new data');
                        insert paa; 
                         LMA_Audit__c lma = new LMA_Audit__c(
                          License_Key__c = Licensekey,
                          License_Type__c = select_LicType,
                          Expire_Date__c =  paa.Expire_date__c,//DateInput.ActivityDate,
                          User_ID__c = UID,
                          Contact__c = '01',
                          Install_Date__c = date.today(),
                          No_of_Seats__c = No_Of_Seats,
                          Package_Version__c = 'v4.1',
                          Subscriber_Org_Id__c = OrgID,
                          App_Name__c = select_module
                         );
                        system.debug('piyush lma key '+ lma.License_Key__c);
                        insert lma;
                        }
                    else if(instanceOrg.User_ID__c != UID && lmaseat.App_Name__c == select_module)
                    {
                            system.debug('Appsameuserdifferent');
                         //   adminseats = [select No_of_Seats__c from LMA_Audit__c where App_Name__c='select_module'];
                          //  csmseats = [select SetupOwnerId from page_access__c where Module_Name__c='select_module'];
                            
                          //  System.debug('adminseats'+adminseats);
                          //  System.debug('csmseats'+csmseats);
                            
                            
                            page_access__c paa = new  page_access__c(SetupOwnerId = UID, Name = OrgName);          
                            paa.License_Key__c = Licensekey;
                            paa.License_Type__c = select_LicType;
                            paa.Module_Name__c=select_module;
                            
                            if(Perpetual == TRUE)
                            {
                                paa.Expire_date__c = date.today();
                            }
                            else
                            {
                                paa.Expire_date__c = DateInput.ActivityDate;
                            }
                            
                        paa.Perpetual__c = Perpetual;
                        paa.License_no__c = No_Of_Seats;
                        paa.Org_ID__c = OrgID;
                        paa.User_ID__c = UID;
                        paa.Tabs__c=temp;
                        system.debug('ashok in try ');
                        insert paa; 
                         LMA_Audit__c lma = new LMA_Audit__c(
                          License_Key__c = Licensekey,
                          License_Type__c = select_LicType,
                          Expire_Date__c =  paa.Expire_date__c,//DateInput.ActivityDate,
                          User_ID__c = UID,
                          Contact__c = '01',
                          Install_Date__c = date.today(),
                          No_of_Seats__c = No_Of_Seats,
                          Package_Version__c = 'v4.1',
                          Subscriber_Org_Id__c = OrgID,
                          App_Name__c = select_module
                         );
                        system.debug('ashok lma key '+ lma.License_Key__c);
                        insert lma;
                        }
                    else if(lma1.App_Name__c != select_module && lma1.User_ID__c == UID )
                    {
                          //  system.debug('usersameappdifferent');
                          //  adminseats = [select No_of_Seats__c from LMA_Audit__c where App_Name__c='select_module'];
                          //  csmseats = [select SetupOwnerId from page_access__c where Module_Name__c='select_module'];
                           
                          //  System.debug('PIYUSHadminseats'+adminseats);
                          //  System.debug('PIYUSHcsmseats'+csmseats);
                            
                          //  if(adminseats.size() > csmseats.size())
                          //  {
                            system.debug('ashok duplicate app ');
                            LMA_Audit__c lma = new LMA_Audit__c(
                            License_Key__c = Licensekey,
                            License_Type__c = select_LicType,
                            Expire_Date__c =  instanceUser.Expire_date__c,//DateInput.ActivityDate,
                            User_ID__c = UID,
                            Contact__c = '01',
                            Install_Date__c = date.today(),
                            No_of_Seats__c = No_Of_Seats,
                            Package_Version__c = 'v4.1',
                            Subscriber_Org_Id__c = OrgID,
                            App_Name__c = select_module
                            );
                             insert lma;
                             //   PageReference p = new PageReference('/apex/CG_Licensekey');
                             //   p.setRedirect(true);
                                
                            }
                            /*else
                            {
                                PageReference p = new PageReference('/apex/CG_Licensekey');
                                p.setRedirect(true);
                            }*/
                        }
                    catch(Exception e){system.debug(e.getMessage());}
                    //return ApexPages.currentPage().setRedirect(true);
            
          system.debug('ashok outside try ');
         //---------------------------------ashok end------------------
    /* for(string str : select_tablist)
     {
         temp=temp+str+', ';
     }
     pa.Tabs__c=temp;*/
    // pa.Expire_date__c=DateInput.ActivityDate;
   //  pa.License_no__c=No_Of_Seats;   
   //  insert pa;              
     }
     select_LicType=null; select_module=null; DateInput.ActivityDate=null; No_Of_Seats=null; select_tablist.clear();
     
 } 
  public List<SelectOption> getLicenses()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('none','None'));
        options.add(new SelectOption('EL','Enterprise License'));
        options.add(new SelectOption('IL','Individual App License'));
        return options;
    }
    
  public pagereference LicenseType()
   {
       system.debug('Selected Module is : '+ select_LicType);
       select_module=NULL;
       pagereference pr=new PageReference('/apex/page_access_config');
       return pr;
       
   } 
    
 public List<SelectOption> getobjNames()
    {
    List<Schema.SObjectType> gd = Schema.getGlobalDescribe().Values();
    List<SelectOption> options = new List<SelectOption>();
    options.add(new SelectOption('--None','--None--'));
    for(Schema.SObjectType f : gd)
    {
    if(f.getDescribe().getName().contains('__c'))
    options.add(new SelectOption(f.getDescribe().getName(),f.getDescribe().getName()));
    }
   // system.debug('Nikunj__ All Object in Org Are '+ options);
    return options;
    }
    
  // NIKUNJ: "getTabName()" This code for Display Dynamic Tab according to select module name 
  public pagereference getTabName()
  {
        List<String> tablist = new List<String>{'Home','Reports','Dashboards','Support','Files'};
            
        List<Schema.DescribeTabSetResult> tabSetDesc = Schema.describeTabs();
      
        LT = new list<listTab>();
     
        ns = new list<tablist_IL>();

      system.debug('Nikunj__ Inside TabName Function and Selected License Type is : ' + select_LicType);
       // system.debug('Nikunj  value stored in List : '+Modlist);
        Integer j=0;
      if(select_LicType =='EL')
      {
        for(String s : Modlist)
        {
            if(select_module == s)
           // if(select_module =='ConfidentG')
            {
                for(Schema.DescribeTabSetResult f : tabSetDesc)
                {
                   // options.add(new SelectOption(f.getLabel(),f.getLabel()));
                    String appLabel = f.getLabel();
                    system.debug('Nikunj__ Tab  in Org Are '+ appLabel );
                     if (appLabel == s) 
                     //if (appLabel == 'ConfidentG')
                     {
                         System.debug('Nikunj__ Insside if Loop');
                         List<Schema.DescribeTabResult> tabDesc = f.getTabs();
                         
                         for(Schema.DescribeTabResult tr : tabDesc)
                         { j=0;
                          /*-------------------------------------------------------------------*/
                       System.debug('Nikunj Tab description ');
                        System.debug('getLabel: ' + tr.getLabel());
                        System.debug('getColors: ' + tr.getColors());
                        System.debug('getIconUrl: ' + tr.getIconUrl());
                        System.debug('getIcons: ' + tr.getIcons());
                        System.debug('getMiniIconUrl: ' + tr.getMiniIconUrl());
                        System.debug('getSobjectName: ' + tr.getSobjectName());
                        System.debug('getUrl: ' + tr.getUrl());
                        System.debug('isCustom: ' + tr.isCustom());
                        /*--------------------------------------------------------------------*/
                            string tabname= string.valueOf(tr.getLabel());
                              for(string s1 : tablist )
                              {
                                  if(tabname == s1)
                                   { j=j+1; } //LT.add(new listTab(tabname)); }
                              }
                              if(j==0)
                              { 
                                     System.debug('Nikunj In Enterprise License : ');
                                           select_tablist.add(tr.getLabel());
                                           LT.add(new listTab(tabname,tr.getSobjectName()));                              
                               }
                                  
                           }
                            //  System.debug('Nikunj__ getLabel : ' + tabname + ' &&&&&& : '+tr.getLabel());
                        }
                         
                     }
                  
                 }
             }
        }
      else if(select_LicType=='IL')
      {
          for(String s : Modlist)
        {
            if(select_module == s)
           // if(select_module =='ConfidentG')
            {
                for(Schema.DescribeTabSetResult f : tabSetDesc)
                {
                   // options.add(new SelectOption(f.getLabel(),f.getLabel()));
                    String appLabel = f.getLabel();
                    system.debug('Nikunj__ Tab  in Org Are '+ appLabel );
                     if (appLabel == s) 
                     //if (appLabel == 'ConfidentG')
                     {
                         System.debug('Nikunj__ Insside if Loop');
                         List<Schema.DescribeTabResult> tabDesc = f.getTabs();
                         
                         for(Schema.DescribeTabResult tr : tabDesc)
                         { j=0;
                              string tabname= string.valueOf(tr.getLabel());
                              for(string s1 : tablist )
                              {
                                  if(tabname == s1)
                                   { j=j+1; } //LT.add(new listTab(tabname)); }
                              }
                              if(j==0)
                              { 
                                          System.debug('Nikunj In Individual License :' );
                                          select_tablist.add(tr.getLabel());
                                          ns.add(new tablist_IL(tabname,tr.getSobjectName()));                                
                               }
                                  
                           }
                            //  System.debug('Nikunj__ getLabel : ' + tabname + ' &&&&&& : '+tr.getLabel());
                        }
                         
                     }
                  
                 }
              }
          }
         
     /* for(string t : tablist)
      {
         ns.add(new tablist_IL(t)); 
      }  */
       pagereference pr=new PageReference('/apex/page_access_config');
       return pr;    
     
  }
  
 
 // NIKUNJ: "getTabName()1" This code for Display Dynamic custome module  
  public List<Selectoption> getTabName1()
  {
       // List <String> cmp = new list<String>{'ConfidentG','Governance','Master Data','PMO', 'Risks', 'Rules','Social GRC','Surveys'};
        List <String> cmp1 = new list<String>{'Sales','Call Center','Marketing','Force.com','Authenticated Website User','High Volume Customer Portal User','Community','Content','Salesforce Chatter','Site.com','Profile (Self)','Profile (Others)','App Launcher'};
        List<Schema.DescribeTabSetResult> tabSetDesc = Schema.describeTabs();
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('--None','--None--'));
       // LT.clear();
       Modlist.clear();
        LT = new list<listTab>();
        Integer j=0;                    
       /* for(Schema.DescribeTabSetResult f1 : tabSetDesc)
        {
            String appLabel = f1.getLabel();
            str.add(appLabel);
        } */
       // System.debug('Nikunj Org ALL Tabs are : '+ str);
        for(Schema.DescribeTabSetResult f : tabSetDesc)
        {
        j=0;
        String appLabel = f.getLabel();  
          /*  for(string s : cmp)
            {
                if(appLabel == s)
                {
                   options.add(new SelectOption(f.getLabel(),f.getLabel()));
                }
            } */
           for(string s : cmp1)
            {
                if(appLabel == s)
                {
                j=j+1;
                }
            }
            if(j==0)
            {
                 Modlist .add(f.getLabel());
                 options.add(new SelectOption(f.getLabel(),f.getLabel()));
            }
          
        } 
        system.debug('Nikunj  value in List : '+Modlist);
        return options;
      
  }
 
public page_access__c instance;
    

    public void onUserChange(){
        initLicenseKeys();
        SelectedProfile = '--- Select Profile ---';
    }
    public void onProfileChange(){
        initLicenseKeys();        
        SelectedUser = '--- Select User ---';
    }
    //------ashok
    public pagereference GenerateLicenseKeys(){
      //  LicInfo();
    //new to generate random licenses keys for tabs.
            Integer len = 5;
            Blob blobKey = crypto.generateAesKey(128);
            String key = EncodingUtil.convertToHex(blobKey);
            String pwd = key.substring(0,len);
            System.debug('Licenseskey'+pwd);
            Licensekey = pwd + OrgId;
            System.debug('Licenseskey'+ Licensekey);
            LicInfo(); // call licenses info method.
        
        // Assign the addresses for the To and CC lists to the mail object.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> sendTo = new List<String>();
                        sendTo.add('support@confidentgovernance.com');
                        mail.setToAddresses(sendTo);
                        mail.setReplyTo('support@confidentgovernance.com');
                        // Specify the name used as the display name.
                        mail.setSenderDisplayName('Confident Governance Support');
                        mail.setSubject('ConfidentG Licenses Key Generated');
                        //mail.setPlainTextBody('Your Licensekey: ' + pwd + OrgID +' has been created.');
                String body = 'Dear ' + UserGetName + ', ';
                body += '<br>UserName: ' + UserName + '<br>Email: '+ UserEmail + ' <br>UserType: '+ UserLicense;
                body += '<br><p>Thank you for being user of ConfidentG.<p/>';
                body += '<br>Please find below the License Key information for the product you have ordered.';
                body += '<br><p>Your License Key is: <b>' + pwd + OrgID + '</b></p>';
                body += '<p>Thanks for using ConfidentGovernance.com Governance as a Service® Product.</p>';
                body += '<br><p><b>License Management Team,</b></p>';
                body += '<br><a href = "WWW.ConfidentGovernance.com">ConfidentGovernance.com</a><b>* Governance as a Service® Inventors</b>';
                body += '<br><b>Global Leaders for Confident Governance, Security & Compliance for the Cloud and Enterprise</b>';
                body += '<br><b>E-mail :</b><a href="mailto:support@confidentgovernance.com">support@confidentgovernance.com</a>';
                body += '<br><b>INC. 5000 Award Winning Company * GEW50 Award Winner</b>';
                body += '<br><b>Force.com Cloud Computing ISV Partner * SAP Solutions and Security Partner * Microsoft BizSparks Partner</b>';
                body += '<br><a href="http://www.facebook.com/ConfidentGovernance">http://www.facebook.com/ConfidentGovernance</a>';
                body += '<br><a href="http://www.linkedin.com/company/confident-governance">http://www.linkedin.com/company/confident-governance</a>';
                body += '<br><a href="https://twitter.com/ClearGRC">https://twitter.com/ClearGRC</a>';
                //body += '<br>';
                mail.setHtmlBody(body);
            // Send the email you have created.
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

        pagereference pr=new PageReference('/apex/page_access_config');
        return pr; 
        
        //return pwd;
    }
    //End ashok 
    public page_access__c licenseKeys {
        get {
            if (licenseKeys == null) {
                initLicenseKeys();
            }
            return licenseKeys;
        }
        set;
    }
       private void initLicenseKeys(){       
        if(SelectedUser == '--- Select User ---' && SelectedProfile == '--- Select Profile ---'){
            instance = page_access__c.getOrgDefaults();        
        } 
       /* else if(SelectedUser != '--- Select User ---'){
            ID userID = [Select Id from User Where User.Name =: SelectedUser LIMIT 1].ID;
            instance = page_access__c.getInstance(userID);
        }*/
     /* upload error
         else if(SelectedProfile != '--- Select Profile ---'){
            ID profileID = [Select Id from Profile Where Profile.Name =: SelectedProfile LIMIT 1].ID;
            instance = page_access__c.getInstance(profileID);        
        }   coz of error*/
        //licenseKeys = instance != null ? instance : new page_access__c(SetupOwnerId = UserInfo.getOrganizationId());
        if(instance != null){
            licenseKeys = instance;
        }
        else{
            licenseKeys = new page_access__c(SetupOwnerId = UserInfo.getOrganizationId());
        }
      }
      public List<SelectOption> UserList{
        get
        {
            UserTemp = [Select u.LastName, u.Id, u.FirstName, u.Email, u.Name From User u]; 
            system.debug('Piyushusertemp'+UserTemp);
            UserList = new List<SelectOption>();
                UserList.add(new SelectOption('--- Select User ---' , '--- Select User ---'));
            for(User temp : UserTemp)
            {                
                UserList.add(new SelectOption(temp.Name, temp.Name));
            }
            return UserList;
        }
        set;
    }
    public List<SelectOption> ProfileList{
        get
        {
            ProfileTemp = [Select p.Name, p.Id From Profile p];            
            ProfileList = new List<SelectOption>();
                ProfileList.add(new SelectOption('--- Select Profile ---' , '--- Select Profile ---'));            
            for(Profile temp : ProfileTemp)
            {
                ProfileList.add(new SelectOption(temp.Name, temp.Name));
            }
            return ProfileList;
        }
        set;
    }
    
   // NIKUNJ: "getTabName()" This code for Display Dynamic Tab according to select module name 
    public class listTab
    {
     SecureSettingsController sc = new SecureSettingsController();
      public String tab {get; set;}
      public Boolean check {get; set;}
      public Boolean notuse{get; set;}
      public Boolean ReadOnly {get; set;}
      public string Associated_Object {get; set;}
         public listTab(String t, String obj)
         {
             Associated_Object=obj;          
             check=True;
             tab=t;
        }
    }
    
    public pagereference test ()
    {
        
        system.debug('NSSS : '+ ns.size());
        
      //  for(test t : ns)
         pagereference pr=new PageReference('/apex/page_access_config');
        return pr; 
    }
    public class tablist_IL
    {
        public boolean selected {get; set;}
        public String tab {get; set;}
        public Boolean ReadOnly {get; set;}
        public string Associated_Object {get; set;}
        public Boolean notuse{get; set;}
        
        public tablist_IL(string str, String Obj)
        {
            Associated_Object=obj;
            selected = False;
            tab=str;
            notuse = True;
            //ReadOnly = False;
        }
    }
    
}