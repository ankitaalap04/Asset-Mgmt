/* Description: This class is the controller for the app's asset assignment page */

public with sharing class CAM_AssetAssignController {

    //Variable for errormessage
    public List<ApexPages.Message> errormessages 
    {
        get
        {
            //Get only error messages
            return CAM_SettingsUtil.prepareMessages(ApexPages.getMessages());
           // return CAM_SettingsUtil.prepareMessages(errormessages);
        }

        private set;
    }

    //Variable to store the name of the recordtype selected
    public String assetLabel { get; private set; }

    //Asset ID
    public String assetId {get; set;}

    //Asset Name
    public String assetName {get; set;}

    //Asset Record Type
    public String assetRecordType {get; private set;}   

    //Asset object
    public AM_Asset__c assetObject {get; private set;} 

    //Asset Allocation Start Date
    public Datetime allocationStartDate {get; set;}

    //Asset Allocation Start Date for display
    public String allocationStartDateDisplay {get; set;}    

    //Asset Allocation End Date
    public Datetime allocationEndDate {get; set;}

    //Contact ID
    public String contactId {get; set;}

    //Contact Name
    public String contactName {get; set;}   

    //Contact object
    public Contact contactObject {get; private set;} 

    //Allocation object created
    public AM_Asset_Allocation__c allocationRecord {get; private set;}

     //Boolean to determine if confirmation should be shown or not
    public Boolean showConfirmation {get; private set;} {showConfirmation = false;}    

    //Boolean to determine if look up should be shown or not
    public Boolean showLookUp {get; private set;} {showLookUp = true;}    


    //Constructor
    public CAM_AssetAssignController(ApexPages.StandardController controller) {

        //Set the Record type
        this.assetRecordType = String.escapeSingleQuotes(CAM_SettingsUtil.setAssetRecordTypeId(ApexPages.currentPage().getParameters().get('recType')));

        //Set the asset label
        this.assetLabel = CAM_SettingsUtil.setAssetLabel(this.assetRecordType);

        //Set the allocation start date to now
        this.allocationStartDate = Datetime.now();
        this.allocationStartDateDisplay = allocationStartDate.format();

        //Provide a default value for allocation end date by adding an hour to the start date 
        this.allocationEndDate = allocationStartDate.addHours(1);

        //If the screen is launched via publisher action then set the asset ID
        if(controller.getRecord()!=null && !String.isEmpty(controller.getRecord().id))
        {
            try
            {
                //Get the Asset
                
                this.assetObject = [Select Id,
                                     Name,
                                     AM_Status__c,
                                     AM_Type__c,
                                     AM_Location__c,
                                     AM_Location__r.Name,
                                     AM_Price__c,
                                     Assigned__c,
                                     Available__c
                              from AM_Asset__c
                              where Id = :controller.getRecord().Id limit 1];

                //Set the asset ID
                this.assetId = this.assetObject.Id;

                //Set the asset Name
                this.assetName = this.assetObject.Name;

                //Set the showLookUp to false
                this.showLookUp = false;   
                             
            }
            catch(Exception e) 
            {
                //Add a message if there is an error fetching the asset id
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                                                           String.format('E4: {0} could not be found. Please try again.',
                                                                         new List<String>{this.assetLabel})));

            }

        }        
    }

    /*
    * Description: Method to create the Asset Allocation record
    */
    public PageReference createAllocation()
    {
        //Check if Asset has been selected
        if(String.isEmpty(this.assetId))
        {
            //Add a message that there was an error fetching records
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                                       this.assetLabel + ' field cannot be empty.'));             
        }
        else if(String.isEmpty(this.contactId))
        {
            //Add a message that there was an error fetching records
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                                       'Contact cannot be blank.'));             
        }
        else if(this.allocationEndDate==null || String.isEmpty(allocationEndDate.format()))
        {
            //Add a message that there was an error fetching records
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                                       'Please enter Assign To date.'));             
        }
        else
        {
            try
            {
                //Create asset allocation object
                AM_Asset_Allocation__c newAllocation = new AM_Asset_Allocation__c();
/*Ankita */     AM_Asset__c Asset = new AM_Asset__c();

                //Set fields
                newAllocation.AM_Asset__c = this.assetId;
                newAllocation.AM_Contact__c = this.contactId;
                newAllocation.AM_Start_Date__c = allocationStartDate;
                newAllocation.AM_End_Date__c = allocationEndDate;
                

                //Check if the user has access to create the object record
                if(AM_Asset_Allocation__c.sObjectType.getDescribe().isCreateable())
                {
                    //Insert record
                    Database.SaveResult sr = Database.insert(newAllocation);  

                    //If error show an error message
                    if(!sr.isSuccess())
                    {
                        //Do not show confirmation
                        this.showConfirmation = false;  
            //            Asset.Assigned__c = true;
            //            Asset.Available__c=false;         
                        
                        
            
                                          
                        Database.Error err = sr.getErrors()[0];

                        //Add a message that there was an error creating records
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                                                   'Error creating allocation. ' + err.getMessage()));                      
                    }
                    //If success reset values on the screen
                    else
                    {
                        allocationRecord = newAllocation;
                        this.showConfirmation = true;
                        this.assetId = '';
                        this.assetName = '';
                        this.contactId = '';
                        this.contactName='';
                        
                    }                    
                }
                else
                {
                    //Add a message that there was an error creating records
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                                               'Insufficient access level to create allocation.')); 
                }

            }
            catch (Exception e)
            {
                //Do not show confirmation
                this.showConfirmation = false;
                                     
                //Add a message that there was an error fetching records
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                                           'Error creating allocation. ' + e.getMessage())); 
            }         
        }

        return null;                       
    } 

    /*
    * Description: Method called by the cancel method to go to the home page
    */
    public PageReference goHome()
    {
       /* Pagereference pg1 =  new Pagereference('/apex/CAM_HomePage'); 
        return pg1; */
     
        return new PageReference('/apex/CAM_HomePage');    
       
                 
    } 

    /* 
    * Description: Method called by the cancel method to go to the home page
    */
    public PageReference closeConfirmation()
    {
        this.showConfirmation = false;
        return null;                      
    } 
    
     
    public pagereference backMethod()
    {
        Pagereference pg =  new Pagereference('/apex/CAM_HomePage'); // Include name of page where user should be navigated after clicking on Back button
        pg.setRedirect(true);
        return pg;
    }    
}