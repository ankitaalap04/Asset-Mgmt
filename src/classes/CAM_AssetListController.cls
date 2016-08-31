/* Description: This class is the controller for the app's asset list page */

public with sharing class CAM_AssetListController {

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

    //Standard Set Controller
    public ApexPages.StandardSetController ssc {get; private set;}

    //Variable to store the RecordType parameter sent via URL
    private String assetRecordType;   

    //Variable to store the name of the recordtype selected
    public String assetLabel { get; private set; }

    //Variable for the search term
    public String searchTerm {get; set;}

    //Variable for the search string based on the search term
    public String searchString {
        get 
        {
            return '%' + searchTerm + '%';
        } 

        set;
    } 

    //Variable for 'Status' URL parameter
    public String assetStatus {get; set;}

    //Variable to hold the SOQL query
  @TestVisible  private String assetQuery {get; set;}

    //Map to hold the SelectList selected values
  @TestVisible  public Map<String, String> filterFieldMap { get; private set; }

    //List containing filter fields
   @TestVisible private List<Schema.FieldSetMember> filterFieldList;

    //List containing search fields
   @TestVisible private List<Schema.FieldSetMember> searchFieldList; 

    //Boolean variable to determine the visibility of Search Field
    public Boolean showSearch {get; private set;} {showSearch = false;}

    //Boolean variable to indicate the executeQueryMethod has already been called once within the dynamic component method
    private Boolean queryCalledAlready = false;
  
    //Constructor
    public CAM_AssetListController() {

        //Initialise
       // this.init();
       init();

    }

   /**
     * Description: Initialisation method called in the constructor
     */
    public void init()
    {
        System.debug('Ankita in Init');
        //Initialise Map
        filterFieldMap = new Map<String, String> ();

        //Initialise the Search Term
        this.searchTerm = '';

        //Set the Record type
        this.assetRecordType = String.escapeSingleQuotes(CAM_SettingsUtil.setAssetRecordTypeId(ApexPages.currentPage().getParameters().get('recType')));

        //Set the asset label
        this.assetLabel = CAM_SettingsUtil.setAssetLabel(this.assetRecordType);

        //Get the assetStatus parameter from the URL
        if(!String.isEmpty(ApexPages.currentPage().getParameters().get('assetStatus')))
        {
            this.assetStatus = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('assetStatus'));            
        }

        //Get the list of filter fields in a fieldset
        filterFieldList = SObjectType.AgileAssets__AM_Asset__c.FieldSets.CAM_Asset_List_Filter.getFields();
        system.debug('Ankita  Checking filter field List'+filterFieldList);


        //Get the list of search fields in a fieldset
        searchFieldList = SObjectType.AgileAssets__AM_Asset__c.FieldSets.CAM_Asset_Search_Fields.getFields();
        system.debug('Ankita  Checking field List'+searchFieldList);

        //Loop through the search field list to check if there are any fields of type string
        for(Schema.FieldSetMember searchField : searchFieldList)
        {
            if(searchField.getType() == Schema.DisplayType.STRING || searchField.getType() == Schema.DisplayType.PICKLIST)
            {
                //If there is at least one field of String type then show the search field
                this.showSearch = true;
                break;
            }
        }

    } 

   /**
     * Description: Method to build the Filter screen based on the Fieldset
     */
    public Component.Apex.PageBlockSection getFilterSection()
    {
         filterFieldList = SObjectType.AgileAssets__AM_Asset__c.FieldSets.CAM_Asset_List_Filter.getFields();
        //Create a Page Block Section
        Component.Apex.PageBlockSection filterSection = new Component.Apex.PageBlockSection();

        //Add the asset Status filter selection
        //Create a Label for the Select List Component
        Component.Apex.OutputLabel assetSelectLabel = new Component.Apex.OutputLabel(value = 'Status'); 

        //Create a SelectList for assetstatus field
        Component.Apex.SelectList assetSelectList = new Component.Apex.SelectList(id = 'AgileAssets__AM_Status__c',
                                                                                  multiselect = false,
                                                                                  size = 1); 
        //Set the value property of the SelectList
        assetSelectList.expressions.value = '{!assetStatus}';        

        //Add select options values              
        //Add 'None' Value
        assetSelectList.childComponents.add(this.createSelectOption('Select', ''));

        //Available
        assetSelectList.childComponents.add(this.createSelectOption('Available', CAM_Constants.AM_ASSET_STATUS_AVAILABLE));

        //Assigned
        assetSelectList.childComponents.add(this.createSelectOption('Assigned', CAM_Constants.AM_ASSET_STATUS_ASSIGNED));

        //Out of Service
        assetSelectList.childComponents.add(this.createSelectOption('Out of Service', CAM_Constants.AM_ASSET_STATUS_OUTOFSERVICE));

        //Add the selectlist to filtersection
        filterSection.childComponents.add(assetSelectLabel);
        filterSection.childComponents.add(assetSelectList);

        //Iterate over the field list and create SelectList or Lookup for each field
        for(Schema.FieldSetMember filterField : filterFieldList)
        {
            if( filterField != null )
            {
                if(filterField.getType() == Schema.DisplayType.PICKLIST || filterField.getType() == Schema.DisplayType.REFERENCE )
                    
                {
                    //Create a Label for the Select List Component
                    Component.Apex.OutputLabel selectListLabel = new Component.Apex.OutputLabel(value = filterField.getLabel());

                    //Create a SelectList for this field
                    Component.Apex.SelectList selectListFilter = new Component.Apex.SelectList(id = filterField.getFieldPath(),
                                                                                               multiselect = false,
                                                                                               size = 1);

                    //Create an entry in map with blank value
                    filterFieldMap.put(filterField.getFieldPath(), '');

                    //Set the value property of the SelectList
                    selectListFilter.expressions.value = '{!filterFieldMap[\'' + filterField.getFieldPath() + '\']}';


                    //Add 'None' Value
                    selectListFilter.childComponents.add(this.createSelectOption('Select', ''));

                    //Get the field describe result for the field on the AM_ASSET__c object  
                   Schema.DescribeFieldResult fieldResult = Schema.sObjectType.AgileAssets__AM_ASSET__C.fields.getMap().get(filterField.getFieldPath()).getDescribe();
               
                //    Schema.DescribeFieldResult fieldResult = Schema.SObjectType.AgileAssets__AM_Asset__c.FieldSet.getMap().get(filterField.getFieldPath()).getDescribe();
                    

                    //Picklist Field Type
                    if(filterField.getType() == Schema.DisplayType.PICKLIST)
                    {
                        //Get the Picklist Values
                        List<Schema.PicklistEntry> plEntries = fieldResult.getPicklistValues();
                        
                        //Build the Select Options list    
                        for( Schema.PicklistEntry plEntry : plEntries)
                        {
                            //Add SelectOptions to SelectList
                            selectListFilter.childComponents.add(this.createSelectOption(plEntry.getLabel(), plEntry.getValue()));
                        }
                    }
                    //Lookup Field Type
                    else if(filterField!=null && filterField.getType() == Schema.DisplayType.REFERENCE)
                    {
                        //Create a String variable to store the object name
                        String referenceObjName = '';

                        //Check if there are multiple parent objects for this field
                        if(!fieldResult.isNamePointing())
                        {
                            try
                            {
                                //If there is only one object then get the object name
                                referenceObjName = fieldResult.getReferenceTo()[0].getDescribe().getName();

                                //Create the query to get records (Limit to 50)
                                String query = 'Select Id, Name from ' + referenceObjName + ' Limit 50';

                                //Execute Query
                                List<sObject> plEntries = Database.query(query);

                                //Build the Select Options list    
                                for( sObject plEntry : plEntries)
                                {
                                    //Add SelectOptions to SelectList
                                    selectListFilter.childComponents.add(this.createSelectOption(String.valueOf(plEntry.get('Name')), String.valueOf(plEntry.get('Id'))));
                                }

                            }
                            catch (Exception e)
                            {
                                //Add a message that the name could not be found and skip this field
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 
                                                                           'W1: Cannot find the parent object name. Field will not be added to the filter list'));

                                //Continue to the next entry in FieldSet
                                continue;
                            }

                        }

                        else
                        {
                            //Add a message that the field will not be added to the list since the parent could not be determined
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 
                                                                       'W1: Cannot find the parent object name. Field will not be added to the filter list'));                        

                            //Continue to the next entry in FieldSet
                            continue;
                        }

                    }


                    //Add Label and SelectList to the PageBlockSection
                    filterSection.childComponents.add(selectListLabel);
                    filterSection.childComponents.add(selectListFilter);                    

                }
                else
                {
                    //Add a message that the field will not be added to the list since the Field is neither Picklist nor Lookup
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 
                                                               'W2: ' + filterField.getFieldPath() + ' is neither Picklist nor Lookup. Field will not be added to the filter list'));                                            
                }
            }
            
            else
            {
                //Add a message that the field will not be added to the list since the filterField object is null
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 
                                                           'W3: Could not get the field from Field Set. Field will not be added to the filter list'));                        
            }
        } 

        //Initialise Standard Set Controller if this is the first time the query is being called
        if(!this.queryCalledAlready)
        {
            try
            {
                //Execute Query
                this.executeAssetQuery(); 

                //Mark queryCalledAlready = true so that the query is not called again when this UI is built again.
                this.queryCalledAlready = true;          
            }
            catch (Exception e)
            {
                //Add a message that the there was an error fetching records
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                                           'E1: Error fetching records. ( ' + e.getMessage() + ' )'));                                    
            }            
        }
        

        //Return the UI element   
        return filterSection;
    }

    
    /**
     * Description: Method to initialise the query string
     */
     public void initializeQuery()
     {  
        //If record type is present add the where clause
        if(String.isEmpty(this.assetRecordType))
        {
            this.assetQuery = 'select Id, Name,Item_Name__c, AM_Available_From__c, AM_Comments__c, AM_Location__c, AM_Location__r.Name, AM_Price__c, AM_Status__c, AM_Type__c from AM_Asset__c';                   
        }
        else
        {
            this.assetQuery = 'select Id, Name,Item_Name__c, AM_Available_From__c, AM_Comments__c, AM_Location__c, AM_Location__r.Name, AM_Price__c, AM_Status__c, AM_Type__c from AM_Asset__c where RecordTypeId =: assetRecordType';                   
        }

     } 

    /**
     * Description: Method to fetch the Asset List using StandardSetController
     */
     public List<AM_Asset__c> getAssetRecords()
     {
        return (List<AM_Asset__c>)ssc.getRecords();
     }

    
    public pagereference backMethod()
    {
        Pagereference pg =  new Pagereference('/apex/CAM_HomePage'); // Include name of page where user should be navigated after clicking on Back button
        pg.setRedirect(true);
        return pg;
    }
    /**
     * Description: Method to build the Asset Query based on the parameters selected and execute it.
     */
    public PageReference executeAssetQuery()
    {
        CAM_AssetListController alc=new CAM_AssetListController();
        //Initialise Query
        this.initializeQuery();
        
        
        //Loop through the Fieldset to build the query
        for(String queryField: filterFieldMap.keySet())
        {

            if(!String.isEmpty(filterFieldMap.get(queryField)))
            {

                //If the query contains 'Where' add an 'Add' operator
                if(this.assetQuery.contains(CAM_Constants.AM_WHERE))
                {
                    this.assetQuery += CAM_Constants.AM_SPACE +                                          //Space
                                       CAM_Constants.AM_AND +                                            //AND
                                       CAM_Constants.AM_SPACE +                                          //Space
                                       String.escapeSingleQuotes(queryField) +                          //Field Name
                                       ' = \'' +                                                        // =
                                       String.escapeSingleQuotes(filterFieldMap.get(queryField)) +      //Field Value
                                       '\'';
                }
                //If the query does not contain 'Where' add it
                else
                {
                    this.assetQuery += CAM_Constants.AM_WHERE +                                         //Where
                                       CAM_Constants.AM_SPACE +                                         //Space
                                       String.escapeSingleQuotes(queryField) +                         //Field Name
                                       ' = \'' +                                                       // =
                                       String.escapeSingleQuotes(filterFieldMap.get(queryField)) +     //Field Value 
                                       '\'';   
                }
            }
        }

        //If the user comes to AssetList page by clicking the Graph then show assets accordingly
        if(!String.isEmpty(this.assetStatus))
        {
           if(this.assetStatus.equalsIgnoreCase(CAM_Constants.AM_ASSET_STATUS_OUTOFSERVICE))
            {
                this.addStatusToQuery('AM_Out_of_Service__c', true);           
            }
            else if (this.assetStatus.equalsIgnoreCase(CAM_Constants.AM_ASSET_STATUS_AVAILABLE))
            {
                this.addStatusToQuery('AM_Available_for_allocation__c', true);                
            }
            else if(this.assetStatus.equalsIgnoreCase(CAM_Constants.AM_ASSET_STATUS_ASSIGNED))
            {
                this.addStatusToQuery('AM_Available_for_allocation__c', false);  
                this.addStatusToQuery('AM_Out_of_Service__c', false);               
            }           
        }
        
             

        //Add the Search Term to the query if not searchTerm is not empty and the search field is shown
        if(!String.isEmpty(searchTerm) && showSearch)
        {
            //If the query already contains a 'Where' then add 'AND (' else just add '(' for the Like expression
            if(this.assetQuery.contains(CAM_Constants.AM_WHERE))
            {
                this.assetQuery += CAM_Constants.AM_SPACE +                  //Space
                                   CAM_Constants.AM_AND +                    //AND
                                   String.escapeSingleQuotes(' ( ');        // (
            }
            else
            {
                this.assetQuery += CAM_Constants.AM_WHERE + String.escapeSingleQuotes(' ( ');
            }

            //Add the Fields in the Like expression
            for(Schema.FieldSetMember searchField : searchFieldList)
            {
                //Add only fields of type String
                if(searchField.getType() == Schema.DisplayType.STRING || searchField.getType()== Schema.DisplayType.PICKLIST)
                {
                    //If the query contains LIKE it means that we need to add an OR operator.
                    if(this.assetQuery.contains(CAM_Constants.AM_LIKE))
                    {
                        this.assetQuery += CAM_Constants.AM_SPACE +                                         //Space
                                           CAM_Constants.AM_OR +                                            //OR
                                           CAM_Constants.AM_SPACE +                                         //Space
                                           String.escapeSingleQuotes(searchField.getFieldPath()) +         //Field Name
                                           CAM_Constants.AM_SPACE +                                         //Space
                                           CAM_Constants.AM_LIKE +                                          //LIKE
                                           String.escapeSingleQuotes(' :searchString');                                               //Search String
                    }
                    //If the query does not contain LIKE it means that this is the first LIKE and OR is not needed
                    else
                    {
                        this.assetQuery += CAM_Constants.AM_SPACE +                                         //Space
                                           String.escapeSingleQuotes(searchField.getFieldPath()) +         //Field Name
                                           CAM_Constants.AM_SPACE +                                         //Space
                                           CAM_Constants.AM_LIKE +                                          //LIKE
                                           String.escapeSingleQuotes(' :searchString');                    //Search String
                    }                    
                }   

            }

            //Add ')' at the end of the query
            this.assetQuery += String.escapeSingleQuotes(' )');
        }

        //DEBUG
        //system.debug('*****The query is: ' + this.assetQuery );
        //system.assertEquals('', this.assetQuery);

        try
        {
            //Order the query results
            this.assetQuery += ' Order by Name';

            //DEBUG
            system.debug('The Query: ' + this.assetQuery);

            //Execute query
            ssc = new ApexPages.StandardSetController(Database.query(this.assetQuery));

            //Set Page Size
            ssc.setPageSize(20); 
        }
        catch (Exception e)
        {
            //Add a message that there was an error fetching records
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                                       'E1: Error fetching Asset records. ( ' + e.getMessage() + ' )'));                                                
        }

        return null;
    }

    /**
     * Description: Method to create select option entry
     */
    public Component.Apex.SelectOption createSelectOption(String soLabel, String soValue)
    {
        //Create a SelectOption
        Component.Apex.SelectOption selOption = new Component.Apex.SelectOption();

        //Set Label
        selOption.itemLabel = soLabel;

        //Set Value
        selOption.itemValue = soValue;

        //Return Select Option
        return selOption;       
    }

    /**
     * Description: Method to build where clause based on asset status
     */
    public void addStatusToQuery(String fieldName, Boolean value)
    {
        //If the query already contains a 'Where' then add 'AND' else just add the condition
        if(this.assetQuery.contains(CAM_Constants.AM_WHERE))
        {
            this.assetQuery += ' ' +                                    //Space
                               CAM_Constants.AM_AND +                    //AND
                               ' ' +                                    //Space
                               fieldName +                              //Field Name
                               ' = ' +
                               value;                                   //value
        }
        else
        {
            this.assetQuery += CAM_Constants.AM_WHERE +                  //Where
                               ' ' +                                    //Space
                               fieldName +                              //FieldName
                               ' = ' +
                               value;                                   //value
        }        
    }

}