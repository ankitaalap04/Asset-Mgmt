/* Description: Utilities class for commonly required functionality */


public with sharing class CAM_SettingsUtil {
    //Name of the asset selected
    public static String assetLabel; 
    /**
    * Description: Method to set the AssetLabel based on the recordtype selected
    */
    public static String setAssetLabel(String recordTypeId){

        try
        {
            //Get the RecordType Name based on the record type selection
            RecordType rt = [Select Name from RecordType where id =: recordTypeId];

            //Set the assetName
            assetLabel = rt.Name;
        } catch (Exception e) {
            //Add a message that there was an error fetching records
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 
                                                      'I1: Could not fetch RecordType Name for' + recordTypeId + '. ( ' + e.getMessage() + ' )'));                                                                        
            
      
            //Set assetLabel as blank
            assetLabel = '';            

        }

        //Return the assetName
        return assetLabel;
    }
    /**
    * Description: Method to set the Asset Record Type 
    */
    public static String setAssetRecordTypeId(String recordTypeId){

        //Asset Record Type
        String assetRecordType = '';

        //Set the Record type
        if(String.isEmpty(recordTypeId))
        {
           // If Parameter passed is empty then check if default Record Type is set
            String defaultRecordType = [select Id, AM_Asset_Record_Type__c 
                                        from User 
                                        where Id = :UserInfo.getUserId()
                                        Limit 1].AM_Asset_Record_Type__c;    

            if(!String.isEmpty(defaultRecordType))
            {
                assetRecordType = defaultRecordType;
            }
            else
            {
                //Add a message that there was an error fetching records
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 
                                                          'E3: Please select an Asset Type in the Home page or contact administrator to set default asset type.'));                
            }
        }
        else
        {
            //Use the parameter value to set the record type
            assetRecordType = recordTypeId;
        }

        return assetRecordType;
    }

    /**
    * Description: Prepare a list of messages to be displayed on the screen
    * Parameters: allMessages - List of all ApexPages.getMessage()
    *             includeSeverity - Messages with these severities should be included in the list
    */
    public static List<ApexPages.Message> prepareMessages(List<ApexPages.Message> allMessages)  
    {
        //List of messages to be returned
        list<ApexPages.Message> showMessages = new list<ApexPages.Message>();

        //Loop through the messages and filter out unwanted messages
        for(ApexPages.Message msg: allMessages)
        {
            //Check Severity
            if(msg.getSeverity()==ApexPages.Severity.ERROR)
            {
                showMessages.add(msg);
            }
        }
        return showMessages;       
    }        
}