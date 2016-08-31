/* Description: This class is the controller for the app's home page */

public with sharing class CAM_HomeController {

    /*---- Variables ----*/
    //Variable for errormessage
    public List<ApexPages.Message> errormessages 
    {
        get
        {
            //Get only error messages
            return CAM_SettingsUtil.prepareMessages(ApexPages.getMessages());
        }

        private set;
    }
    
  /*  public string getmyimageurl()
    {
    Organization org = [SELECT id, Name FROM Organization];
    string orgId = org.Id;
    orgId=orgId.substring(0,15);
    String Name = org.Name;    
        
    Document doc = [select id, name,url, body,LastModifiedById from Document where name = 'CG Logo']; 
    string imageid = doc.id;
    id lastmod=doc.LastModifiedById;
     
    imageid = imageid.substring(0,15);
    system.debug('image Id'+imageid);
  //  return '/servlet/servlet.FileDownload?file=' + imageid; 
   // return '/servlet/servlet.ImageServer?id='+ imageid+'&oid='+ orgId+'&lastMod=1466669568000';
   return 'https://'+ApexPages.currentPage().getHeaders().get('Host')+ '/servlet/servlet.ImageServer?id='+imageid+'&oid=' +orgId+'lastMod=1466669568000';
    } */

    //List of available asset record types
    private List<RecordType> rtList= [select Id, 
                                             DeveloperName,
                                             Name 
                                      from RecordType
                                      where sObjectType =: CAM_Constants.AM_ASSET_API_NAME];  

    //List of selectOptions to display record types on the page
    public List<SelectOption> recordTypeOptions {
        get 
        {
            List<SelectOption> options = new List<SelectOption>();
            for (RecordType rt : rtList) 
            {
                //Populate SelectList
                options.add(new SelectOption(rt.Id, rt.Name));
            }
            return options;           
        }
        private set;
    }                                     

    //Number of record types available
    public Integer recordTypeCount {
        get
        {
            return recordTypeOptions.size();
        }
        private set;
    }

    //Logged in user info
    private User loggedInUser = [select Id,
                                        Name,
                                        AM_Asset_Record_Type__c
                                 from User
                                 where Id = :UserInfo.getUserId() limit 1];

    //Record type selection on the home page
    public Id selectedRecordTypeId {get; set;}
    public string myimageurl {get;set;}

    //Label for the object being managed.
    //This variable will be used for all labels and texts
    public String assetlabel {get; private set;}

    //Variable for Total Asset Count
    public Double totalCount {get; private set;}

    //Variable for Available Assets Count
    public Integer availableCount {get; private set;}

    //Variable for Available Assets Count, representing % as Integer
    public Double availablePercentage {get; private set;}
    
    //Variable for Assigned Assets Count
    public Integer assignedCount {get; private set;}

    //Variable for Assigned Assets Count, representing % as Integer
    public Double assignedPercentage {get; private set;}

    //Variable for Out Of Service Assets Count
    public Integer outOfServiceCount {get; private set;}

    //Variable for Out of Service Assets Count, representing % as Integer
    public Double outOfServicePercentage {get; private set;}

    //Variable for Case List
    public List<Service_Request__c> caseList {get; private set;}                                 

    /*---- /Variables ----*/

    /*---- Constructors ----*/

    public CAM_HomeController() 
    {   
        //Initiate the home page
        this.init();
    }

    /*---- /Constructors ----*/

    /*---- Methods ----*/

    /*
    * Description: Method to initiate the homepage content
    */    
    public void init()
    {
        //Check if there are any Record Types created.
        if(rtList==null || rtList.isEmpty())
        {
            //If no record types are not created throw an error
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                                       'E2: Did not find asset record types. Please contact administrator.'));                                                                                    
        }
        //Continue with the logic
        else
        {
            //Initialize counts
            this.availableCount = 0;
            this.assignedCount = 0;
            this.outOfServiceCount = 0;
            this.totalCount = 0;

            //Set the selectedRecordTypeId
            if(String.isEmpty(loggedInUser.AM_Asset_Record_Type__c))
            {
                //selectedRecordTypeId is the first row of the rt query result
                selectedRecordTypeId = rtList[0].Id;
            }
            else
            {
                //Test that the User field contains a valid Record ID
                if(!String.isEmpty(CAM_SettingsUtil.setassetLabel(loggedInUser.AM_Asset_Record_Type__c)))
                {
                    //selectedRecordTypeId is the value set in User record
                    selectedRecordTypeId = loggedInUser.AM_Asset_Record_Type__c;                                                  
                }
                else
                {
                    //selectedRecordTypeId is the first row of the query result
                    selectedRecordTypeId = rtList[0].Id;                                                   
                }
            }

            //Set the Asset Label - Call the static method to set the asset label
            this.assetLabel = CAM_SettingsUtil.setassetLabel(this.selectedRecordTypeId);

            //Get Counts
            this.getCounts();

            //Get Alerts list
            this.getCaseList();            
        }
    }

    /*
    *  Description: Method to set custom settings value
    */
    public void refreshHomepage()
    {
        //Set the value in User record
        loggedInUser.AM_Asset_Record_Type__c = this.selectedRecordTypeId; 

        //Change asset label as per selelction
        this.assetlabel = CAM_SettingsUtil.setassetLabel(this.selectedRecordTypeId);    

        //Check if the field can be updated by the user
        if (Schema.sObjectType.User.fields.AM_Asset_Record_Type__c.isUpdateable())
        {
            //Update the user record
            update loggedInUser;
        }
        else
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,
                                                      'Insufficient access to update AM_Asset_Record_Type__c on User'));            
        }  
       
        //Get Counts
        this.getCounts();

        //Get Alerts List
        this.getCaseList();
    }

    /*
    * Method to get asset counts
    */
    public void getCounts()
    {
        //Reset all count to 0 before calculating counts
        this.availableCount = 0;
        this.assignedCount = 0;
        this.outOfServiceCount = 0;
        this.totalCount = 0;

        //Create a list for asset counts
        List<AggregateResult> assetCounts = new List<AggregateResult>();

        try
        {
            //Get the count for the different value of AM_Available_for_allocation__c checkbox based on the record type selected
            assetCounts = [SELECT AM_Available_for_allocation__c, OOSTest_Available__c,
                                  COUNT(Id) c
                           FROM AM_Asset__c 
                           WHERE RecordTypeId =: this.selectedRecordTypeId
                           GROUP BY AM_Available_for_allocation__c,OOSTest_Available__c];            
        }
        catch (Exception e)
        {
            //Add a message that there was an error fetching records
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                                       'E3: Error fetching Asset records. ( ' + e.getMessage() + ' )'));                                                                        
        }
                                       
                                                    
        //Loop through the list and assign Available and Assigned counts
        for(AggregateResult assetCount: assetCounts)
        {
            //Check if assetCount is null
            if( assetCount!=null )
            {

                //Variable for Count of asset status
                Integer statusCount = Integer.valueOf(assetCount.get('c'));

                //Count for Available assets
                if(assetCount.get('AgileAssets__AM_Available_for_allocation__c')==true)
                {
                    this.availableCount = statusCount;
                }
                //Count for Assigned assets
            /*    else if(assetCount.get('AgileAssets__Assigned__c')==true)
                {
                    this.assignedCount = statusCount;
                    this.availableCount= this.availableCount-this.assignedCount;  
                }   */
             /*   else if(assetCount.get('AgileAssets__AM_Available_for_allocation__c') && ('AgileAssets__AM_Out_of_Service__c')==false) 
                {
                    this.assignedCount = statusCount;
                    this.availableCount= this.availableCount-this.assignedCount; 
                } */
 /*Ankita */      else if(assetCount.get('AgileAssets__OOSTest_Available__c')==false) 
                 /* else if(assetCount.get('AgileAssets__OOSTest_Available__c')==true) */
                {
                    this.assignedCount=statusCount;
                    this.availableCount= this.availableCount-this.assignedCount;
                }     
            }
          /*  else if(assetCount.get('AgileAssets_AM_Asset__c')==true)
            {
                this.assignedCount = statusCount;
            } */
            else
            {
                    //Add a message that assetcount is null
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                                               'E6: Asset count is 0.'));                                                            
            }
        }

        //Get the Out of Service counts
          this.outOfServiceCount = [select COUNT() from AM_Asset__c 
                                  where RecordTypeId =: this.selectedRecordTypeId 
                                  AND AM_Out_of_Service__c = :true];
        
      /*  this.assignedCount = [select count() from AM_Asset__c where RecordTypeId =: this.selectedRecordTypeId
                              AND AgileAssets__Assigned__c = :false];  */

        //Calculate the total count
        this.totalCount = this.availableCount + this.assignedCount + this.outOfServiceCount;

        //Calculate the percentages for each variable if total is not 0 . 
        //Need to use Double versions of the int values for correct totals.
        if(totalCount>0)
        {
            //Available
            this.availablePercentage = (this.availableCount / this.totalCount) * 100;

            //Assigned
            this.assignedPercentage = (this.assignedCount / this.totalCount) * 100;

            //Out of Service
            this.outOfServicePercentage = (this.outOfServiceCount / this.totalCount) * 100;
        }
        //TotalCount = 0
        else
        {
            this.availablePercentage = 0.0;
            this.assignedPercentage = 0.0;
            this.outOfServicePercentage = 0.0;
        }
    }

    /*
    * Method to get the Alerts list (Cases Ordered by recently modified date)
    */
    public void getCaseList()
    {
        try
        {
            //Get the top 10 most recent list of cases for the selected record type
            this.caseList = [SELECT AM_Asset__r.Name,
                                    Owner.Name,
                                    CreatedBy.Name,
                                    Status__c,
                                    Subject__c,
                                    LastModifiedDate,
                                    AM_Asset__r.RecordTypeId
                             FROM Service_Request__c
                             where AM_Asset__r.RecordTypeId = :this.selectedRecordTypeId
                             ORDER BY LastModifiedDate DESC
                             limit 10];            
        }
        catch (Exception e)
        {
            //Add a message that there was an error fetching records
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                                       'E3: Error fetching Alert records. ( ' + e.getMessage() + ' )'));                                                            
        }
    }
    
    /*---- /Methods ----*/
}