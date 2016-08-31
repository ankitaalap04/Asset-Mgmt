@isTest(seeAllData = false)

public class CAM_Request_Page_Test
{
    public String RequestName {get; set;}
    public String btype {get; set;}
    public String stage {get; set;}
    public String stagedata {get; set;}
    public integer quantity{get;set;}
    //public integer probability {get; set;}
    public integer amount {get; set;}
    public String leadSource {get; set;}
    public String nextStep {get; set;}
    public String description {get; set;}
    public Attachment AttachedFile{get;set;}
    //public Boolean itemValue {get; set;}
    //public Date closeDate = date.today();
    
 //   List<Opportunity> listOpportunities = new List<Opportunity>();
   public List<Asset_Requested__c> listAssetRequest = new List<Asset_Requested__c>();
    
    public static testmethod void testattachments()
    {
     Asset_Requested__c ar = new Asset_Requested__c();   
   //  ApexPages.StandardController sc= new ApexPages.StandardController(ar);
     CAM_Request_Page rp = new CAM_Request_Page(); 
        
    ar.Request_Name__c='TestSample';
    ar.Description__c='Test Description';
    ar.Request_Type__c='Purchase';
    ar.Asset_Category__c='IT';
    ar.Asset_Type__c='General';
    ar.Quantity__c= 2;
    ar.Request_Date__c=date.today();
   // listAssetRequest.add(ar);
    insert ar;
     
	Attachment attach = new Attachment();
	attach.name = 'attachment';
//	attach.Body = Blob.valueOf('Attachment');
//	attach.parentId = ar.Id;
//	Insert attach;
//    rp.upload();
    }
    

   

    public static testmethod void MyUnitTest(){ 
     List<Asset_Requested__c> listAssetRequest = new List<Asset_Requested__c>();
     Asset_Requested__c ar = new Asset_Requested__c();
     CAM_Request_Page reqpage=new CAM_Request_Page();
    // ApexPages.StandardController sc= new ApexPages.StandardController(ar);
     CAM_Request_Page rp = new CAM_Request_Page(); 

    
    ar.Request_Name__c='TestSample';
    ar.Description__c='Test Description';
    ar.Request_Type__c='Purchase';
    ar.Asset_Category__c='IT';
    ar.Asset_Type__c='General';
    ar.Quantity__c= 2;
    ar.Request_Date__c=date.today();
    listAssetRequest.add(ar);
    insert ar;
     
	Attachment attach = new Attachment();
	attach.name = 'attachment';
	attach.Body = Blob.valueOf('Attachment');
	attach.parentId = ar.Id;
	Insert attach;
        
    
   

//     rp.getItems();
//     rp.getLeadSources();
     rp.getStages();
     rp.getTypes(); 
     rp.getAttachedFile();
        
     rp.requestform(); 
//     rp.attachFile(listAssetRequest);
     
     rp.getStagesdata();
        
     
        
     
    
     //tstmtd_apxc_Request_Page trp = new tstmtd_apxc_Request_Page();
       // trp.getprobability();
       
        
    }
    
    public string getleadSource(){ return 'test';}
    public string getnextStep(){ return 'test';}
    //public integer getprobability(){ return 15;}
    public integer getamount(){ return 45;}
    
    
    
    public PageReference requestform1() {
//    Opportunity Opp = new Opportunity();
    Asset_Requested__c ar = new Asset_Requested__c();   
    
    ar.Request_Name__c='TestSample';
    ar.Description__c='Test Description';
    ar.Request_Type__c='New Business';
    ar.Asset_Category__c='Review';
    ar.Asset_Type__c='Draft';
    ar.Quantity__c= 2;
    ar.Request_Date__c=date.today();
    listAssetRequest.add(ar);
/*    Opp.Name = 'TestSample';
    Opp.Type = 'New Business';
    Opp.StageName = 'Review';
//    Opp.Scope_of_Initiative__c = 'Draft';
    Opp.Description = 'adescription';
    Opp.CloseDate = date.today();
    listOpportunities.add(Opp); */
    
    if (listAssetRequest.isEmpty() == false) {
        Database.insert(listAssetRequest);
        
    	ar.Request_Name__c='';
    	ar.Description__c='';
    	ar.Request_Type__c='';
    	ar.Asset_Category__c='';
   		ar.Asset_Type__c='';
   	 	ar.Quantity__c= 2;
        
        RequestName = '';
        btype = '';
        stage  = '';
        stagedata = '';
        quantity=null;
        //probability = null;
        amount = null;
        leadSource = '';
        nextStep = '';
        description = '';
    }
    PageReference prf = new PageReference('/apex/CAM_RequestPage');
    prf.setRedirect(true);
    return prf;
        
   // return null;
    }

}