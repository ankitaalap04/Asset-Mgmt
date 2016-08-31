/*Description: This class is the controller for the app's Contact list page*/

public with sharing class CAM_ContactListController {

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

    //Variable to hold the SOQL query
    private String contactQuery {get; set;} {contactQuery = '';}   

    //Variable for the search term
    public String searchTerm {get; set;}

    //Variable for the search string based on the search term
    public String searchString 
    {
        get 
        {
            return '%' + searchTerm + '%';
        }
         
        set;
     }

    //Constructor
    public CAM_ContactListController() {

        //Initialize search term
        searchTerm = '';

        //Search contacts
        this.executeQuery();
    }   

    /**
     * Description: Method to fetch the Asset List using StandardSetController
     */
     public List<Contact> getContactRecords()
     {
         return (List<Contact>)ssc.getRecords();
     }
    
     public pagereference backMethod()
	{
		Pagereference pg =  new Pagereference('/apex/CAM_HomePage'); // Include name of page where user should be navigated after clicking on Back button
		pg.setRedirect(true);
		return pg;
	}
    /**
     * Description: Method to refresh variable values when search is invoked
     */
    public void executeQuery() 
    {
        //Without search term 
        if (searchTerm == null || searchTerm.equalsIgnoreCase('')) 
        {
            this.contactQuery = 'SELECT Id, Name, FirstName, LastName, Email, Phone FROM Contact ORDER By Name';            
        } 
        //With search term
        else 
        {
            this.contactQuery = 'SELECT Id, Name, FirstName, LastName, Email, Phone FROM Contact WHERE (FirstName LIKE :searchString OR LastName LIKE :searchString OR Email LIKE :searchString) ORDER by Name';
        }  

        try
        {
            //Execute query
            ssc = new ApexPages.StandardSetController(Database.query(this.contactQuery));

            //Set Page Size
            ssc.setPageSize(10); 
        }
        catch (Exception e)
        {
            //Add a message that there was an error fetching records
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'E1: Error fetching records. ( ' + e.getMessage() + ' )'));                                                
        }             
    }
    
}