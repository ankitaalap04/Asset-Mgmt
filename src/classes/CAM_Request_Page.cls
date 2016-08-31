Public class CAM_Request_Page{
    
    public Attachment getAttachedFile(){
    attachedFile = New Attachment();
    return attachedFile;
    }
    public Attachment attachedFile;
    public String RequestName {get; set;}
    public String btype {get; set;}
    public String stage {get; set;}
    public String stagedata {get; set;}
    public integer quantity{get;set;}
  
 
    public String description {get; set;}
    public String Filename {get; set;}
    

     public Date requestDate = date.today();
    
     ID currentID;
    List<Asset_Requested__c> listAssetRequest = new List<Asset_Requested__c>();
 
    public CAM_Request_Page(){
    getTypes();
    getStages();
    getStagesdata();
    }  
    public List<SelectOption> getTypes()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('--None','--None--'));
        options.add(new SelectOption('Purchase','Purchase'));
        options.add(new SelectOption('Allocation','Allocation'));
        options.add(new SelectOption('Service/Repair','Service/Repair'));
        return options;
    }
    public List<SelectOption> getStages()
    {
        List<RecordType> rtList= [select  Name,DeveloperName
                                          from RecordType
                                          where sObjectType =: CAM_Constants.AM_ASSET_API_NAME];  

        List<SelectOption> options=new List<SelectOption>();
       
        options.add(new SelectOption('--None','--None'));
        for (RecordType rt : rtList) 
            {
                //Populate SelectList
                options.add(new SelectOption(rt.Name, rt.Name));
             
            }
        return options; 
        
    
        
    } 
     public List<SelectOption> getStagesdata()
    {
      
        
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('--None','--None--'));
        options.add(new SelectOption('Desktop/Laptop','Desktop/Laptop'));
        options.add(new SelectOption('Accessories','Accessories'));
        options.add(new SelectOption('Networking','Networking'));
        options.add(new SelectOption('General','General'));
        options.add(new SelectOption('Book','Book'));
        options.add(new SelectOption('Chromebook','Chromebook'));
        options.add(new SelectOption('Office Furniture','Office Furniture'));
        options.add(new SelectOption('Domestic Item','Domestic Item'));
        options.add(new SelectOption('CD/DVD','CD/DVD'));
        options.add(new SelectOption('Other','Other'));
        return options;
    } 

    public PageReference requestform() {


    Asset_Requested__c ar = new Asset_Requested__c();
    ar.Request_Name__c=RequestName;
    ar.Description__c=description;
    ar.Request_Type__c=btype;
    ar.Asset_Category__c=stage;
    ar.Asset_Type__c=stagedata;
    ar.Quantity__c=quantity;
    ar.Request_Date__c=requestDate;
 
        listAssetRequest.add(ar);
    
    if (listAssetRequest.isEmpty() == false) {
        Database.insert(listAssetRequest);
        for(Asset_Requested__c ars: listAssetRequest){
        system.debug(' ID of inserted request record'+ ars.Id);
        currentID = ars.Id;
        system.debug(' ID of currentID record'+ currentID);
         if(attachedFile.Name != Null)
         {   
            Attachment a = new Attachment(ParentId = ars.Id, name = attachedFile.Name, body = attachedFile.Body);
            insert a; }
        }
        
        RequestName = '';
        btype = '';
        stage  = '';
        stagedata = '';
        quantity=null; 
        description = '';
    }
    PageReference prf = new PageReference('/apex/CAM_RequestPage');
    prf.setRedirect(true);
    return prf;
 
    }
}