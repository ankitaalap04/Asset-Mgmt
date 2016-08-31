/* Description: This class is the controller for the look up component */

public with sharing class CAM_LookUpComponentController {

    //Variable for errormessage
    public List<ApexPages.Message> compErrorMessages
      {
        get
        {
            //Get only error messages
            return CAM_SettingsUtil.prepareMessages(ApexPages.getMessages());
        }

        private set;
    } 
    
    List<AM_Asset__c> assets;
	public List<AM_Asset__c> getAssets() {

		if(assets == null) 
            assets = [select Name,Item_Name__c,AM_Status__c from AM_Asset__c limit 5];

		return assets;

	}
    
     List<Contact> conrecs;
	public List<Contact> getcontactRecord() {

		if(conrecs == null) 
            conrecs = [select Name,Email from Contact limit 5];

		return conrecs;

	}
    


    //Look up object name
    private final AM_Asset__c ast;
    public String lookupObjectName {get; set;}

    //Asset Record Type
    public String assetRecordType {get; set;}

    //Asset Status
    public String assetStatus {get; set;}

    //List for storing the Asset lookup values
    public List <AM_Asset__c> assetLookupValues {get; private set;} 

    //List for storing the Asset lookup values
  @testVisible  public List <Contact> contactLookupValues {get; private set;} 

    //Lookup query
    public String lookupQuery {get; set;}
    
    //show default data
    public boolean defaultdata{get; private set;}{defaultdata=true;}

    //Show Asset Lookup
    public Boolean showAsset {get; private set;} {showAsset = false;}

    //Show Asset Lookup
    public Boolean showContact {get; private set;} {showContact = false;}    

    public ApexPages.StandardSetController ssc {get; private set;}
   

    //Constructor
    public CAM_LookUpComponentController() {
       
    }
    public List<Contact> getContactRecords()
     {
         return (List<Contact>)ssc.getRecords();
        
     }
    
    public PageReference runQuery()
    {
        //Check 
        if(String.isEmpty(this.lookupQuery) || this.lookupQuery.length()==1)
        {
            //Add a message that the search term is less than a character.
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                                       'E3: Search term cannot be 1 character. Please change the search term.'));            
          
        }
        else if(String.isEmpty(this.lookupObjectName))
        {
            //Add a message that lookup object is not specified
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                                       'E4: LookUp object could not be determined. Please try again. If the error persists contact administrator'));             
        }
        else if(this.lookupObjectName.equalsIgnoreCase(CAM_Constants.AM_ASSET_API_NAME))
        {
            //Initialise search results list
            List<List<AM_Asset__c>> searchResults = new List<List<AM_Asset__c>>();

            //Check if recordtype has been passed
            if(String.isEmpty(this.assetRecordType))
            {

                //Add a message that recordtype is not specified
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                                           'E5: Record Type could not be determined. Please try again. If the error persists contact administrator'));                              
            }
            else
            {
                try
                {
                    //If status is not provided then remove it from where clause
                    if(!String.isEmpty(this.assetStatus))
                    {
                        searchResults = [FIND :lookupQuery IN ALL FIELDS RETURNING AM_Asset__c (id, 
                                                                                                name, 
                                                                                                AM_Location__c,
                                                                                                Item_Name__c,
                                                                                                AM_Location__r.Name, 
                                                                                                AM_Status__c, 
                                                                                                AM_Type__c,
                                                                                                AM_Out_of_Service__c,
                                                                                                AM_Price__c 
                                                                                                where AM_Available_for_allocation__c= true
                                                                                                AND RecordTypeId = :assetRecordType)];                    
    
                    }
                    else
                    {
                        searchResults=[FIND :lookupQuery IN ALL FIELDS RETURNING AM_Asset__c (id, 
                                                                                              name,
                                                                                              Item_Name__c,
                                                                                              AM_Location__c, 
                                                                                              AM_Location__r.Name,
                                                                                              AM_Status__c, 
                                                                                              AM_Type__c ,
                                                                                              AM_Out_of_Service__c,
                                                                                              AM_Price__c
                                                                                              where RecordTypeId = :assetRecordType)];
                    }
    
                    assetLookupValues=searchResults[0]; 
    
                    //Show the table
                    this.showAsset = true;
    
                    //Hide other tables
                    this.showContact = false;  
                    this.defaultdata =false;
                }
                catch (Exception e)
                {
                    //Add a message that there was an error fetching records
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                                               'E3: Error fetching Asset records. ( ' + e.getMessage() + ' )'));                     
                }               
            }


        }
        else if(this.lookupObjectName.equalsIgnoreCase(CAM_Constants.AM_CONTACT_API_NAME))
        {
            try
            {
                List<List<Contact>> searchResults=[FIND :lookupQuery IN ALL FIELDS RETURNING Contact (id, 
                                                                                                      name,
                                                                                                      email,
                                                                                                      phone)];
                contactLookupValues=searchResults[0]; 

                //Show the table
                this.showContact = true;

                //Hide other tables
                this.showAsset = false; 
				this.defaultdata =false;                
            }
            catch (Exception e)
            {
                //Add a message that there was an error fetching records
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                                           'E3: Error fetching Contact records. ( ' + e.getMessage() + ' )')); 
            }    
             
        }   

        return null;
    }   

}