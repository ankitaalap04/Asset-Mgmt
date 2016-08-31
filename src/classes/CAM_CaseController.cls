/* Description: This class is the controller for the case creation page */

public with sharing class CAM_CaseController{

    //Variable for errormessage
    public List<ApexPages.Message> errormessages 
    {
        get
        {
            //Get only error messages
           return CAM_SettingsUtil.prepareMessages(ApexPages.getMessages());
           //return CAM_SettingsUtil.prepareMessages(allMessages);
        }

        private set;
    }
    
    //Asset Name
    public String assetName {get; set;}  

    //Asset Object 
    public AM_Asset__c asset {get; set;}

    //Case Object
    public Service_Request__c aCase {get; set;}

    //New Case Id
    public Id newCaseId {get; private set;}

    //Attachment Object
    public Attachment attach {get; set;}

    //Attachment Name
    public String attachmentName {get; set;}

    //RecordType parameter sent via URL
    public String assetRecordType {get; set;}

    //Asset Label
    public String assetLabel {get;private set;}

     //Boolean to determine if confirmation should be shown or not
    public Boolean showConfirmation {get; private set;} {showConfirmation = false;}     

    //Boolean to determine if look up should be shown or not
    public Boolean showLookUp {get; private set;} {showLookUp = true;}

    //Constructor
    public CAM_CaseController(ApexPages.StandardController controller) {

        //Set the Record type
        this.assetRecordType = CAM_SettingsUtil.setAssetRecordTypeId(ApexPages.currentPage().getParameters().get('recType'));

        //Set the Asset Label
        this.assetLabel = CAM_SettingsUtil.setAssetLabel(this.assetRecordType);

        //Initialise the case
       // this.aCase = new Case();
       this.aCase=new Service_Request__c();

        //If the screen is launched via publisher action then set the asset ID
        if(controller.getRecord()!=null && !String.isEmpty(controller.getRecord().id))
        {
            try
            {
                //Get the Asset
                this.asset = [Select Id,
                                     Name
                              from AM_Asset__c
                              where Id = :controller.getRecord().Id limit 1];

                //Set the asset ID
                aCase.AM_Asset__c = this.asset.Id;

                //Set the asset Name
                this.assetName = this.asset.Name;

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

        //Initialise the attachment
        this.attach = new Attachment(); 
    }

    public PageReference createCase() 
    {
        //Check if Asset has been selected
        if(aCase.AM_Asset__c == null || String.isEmpty(aCase.AM_Asset__c))
        {
            //Add a message that there was an error fetching records
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                                       this.assetLabel + ' field cannot be empty.'));             
        }
        else if(String.isEmpty(aCase.Subject__c))
        {
            //Add a message that there was an error fetching records
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                                       'Subject cannot be blank.'));             
        }
        else if(String.isEmpty(aCase.Description__c))
        {
            //Add a message that there was an error fetching records
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                                       'Description cannot be blank.'));             
        } 
        else
        {
            //Create case
            try 
            {
                //Get the record type associated with the Asset Management app
 //               RecordType caseRecordType = [Select Id from RecordType where DeveloperName =: CAM_Constants.AM_CASE_RT_NAME Limit 1];

                //Set the new case's record Type
 //               aCase.RecordTypeId = caseRecordType.Id;

                //Check if the user has access to create the object record
//                if(User.sObjectType.getDescribe().isCreatable())
                    
//                {
                    //Insert record
                    Database.SaveResult sr = Database.insert(aCase); 
                    aCase.CreatedDate__c=system.today();
                    
                    //If error show an error message
                    if(!sr.isSuccess())
                    {
                        //Do not show confirmation
                        this.showConfirmation = false;  
                      //  aCase.CreatedDate__c=system.today();
                                          
                        Database.Error err = sr.getErrors()[0];

                        //Add a message that there was an error creating records
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                                                   'Error creating Case. ' + err.getMessage())); 
                                                                                      
                    }
                    //If case creation is success, create the attachment
                    else
                    {
                        //If attachment is uploaded by user then attach it to the case
                        if(aCase != null && !String.isEmpty(aCase.id) && 
                           !String.isEmpty(attach.name) && 
                           attach.body != null) 
                        {
                            //Set the newly created case as the parent of the attachment
                            attach.ParentId = aCase.Id;
                            

                            //Insert the attachment
                            try 
                            {
                                //Check if the user has access to create the object record
                                if(Attachment.sObjectType.getDescribe().isCreateable())
                                {
                                    //Insert record
                                    Database.SaveResult sresult = Database.insert(attach); 

                                    //If error show an error message
                                    if(!sresult.isSuccess())
                                    {
                                        //Do not show confirmation
                                        this.showConfirmation = false;  
                                                          
                                        Database.Error err = sresult.getErrors()[0];

                                        //Add a message that there was an error creating records
                                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                                                                   'Case created, but attachment could not be added. Please contact administrator' + err.getMessage()));                      
                                        
                                    }
                                    //Else reset everything and show confirmation
                                    else
                                    {
                                        newCaseId = aCase.Id;
                                        aCase = new Service_Request__c(CreatedDate__c=system.today());
                                        this.assetName = '';
                                        attach = new Attachment();
                                        this.showConfirmation = true;
                                    }
                                }
                                else
                                {
                                    //Do not show confirmation
                                    this.showConfirmation = false;
                    
                                    //Add a message if there is an error creating case
                                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                                                                               'Insufficient access level to create attachments.'));                    

                                }                

                            } 
                            catch (Exception e) 
                            {
                                //Do not show confirmation
                                this.showConfirmation = false;
                                
                                //Add a message if there is an error creating an attachment
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                                                                           String.format('Case created, but attachment could not be added. Please contact administrator. {0}',
                                                                                         new List<String>{e.getMessage()})));

                            }            
                        }

                        else
                        {   
                            newCaseId = aCase.Id;
                            aCase = new Service_Request__c(CreatedDate__c=system.today());
                            this.assetName = '';
                            this.showConfirmation = true;
                        }                        
                        
                    }
 //               }
//                else
                {
                    //Do not show confirmation
                    this.showConfirmation = true; 
                    
                    //Add a message that there was an error creating records
//                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
//                                                               'Insufficient access level to create case')); 
                
                }

            } catch (Exception e) 
            {
                //Do not show confirmation
                this.showConfirmation = false; 
                
                //Add a message if there is an error creating case
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                                                           String.format('Error creating case. {0}',
                                                                         new List<String>{e.getMessage()})));
            }
             
        }       


        return null;
  
        
    }
    
    public pagereference backMethod()
    {
       Pagereference pg =  new Pagereference('/apex/CAM_HomePage'); // Include name of page where user should be navigated after clicking on Back button
       pg.setRedirect(true);
       return pg;
    }

    /*
    * Description: Method called by the cancel method to go to the home page
    */
    public PageReference closeConfirmation()
    {
        this.showConfirmation = false;
        return null;                      
    }
     
}