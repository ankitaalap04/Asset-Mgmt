/*  Test class for the AM_ContactListController */

@isTest
private class CAM_ContactListController_Test {
    
    @isTest static void test_method_one() {

        CAM_TestUtilities.createTestContacts(3);
        CAM_ContactListController con = new CAM_ContactListController();         
        
        PageReference contactList = Page.CAM_ContactListPage;
        list<ApexPages.Message> msg = con.errormessages;
        Test.setCurrentPage(contactList);
        
        list<contact> getrec = con.getContactRecords();

        System.assertEquals(con.ssc.getResultSize(), 3);
        
        con.searchTerm = 'Test';
        con.executeQuery();

        System.assertEquals(con.ssc.getResultSize(), 3);

        con.searchTerm = '1';
        con.executeQuery();


        System.assertEquals(con.ssc.getResultSize(), 1);

        con.searchTerm = 'x';
        con.executeQuery();

        System.assertEquals(con.ssc.getResultSize(), 0);
        
        con.backMethod();
     
    }
    
}