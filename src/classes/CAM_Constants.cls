/* Description: This class contains all constants used in this app's Apex classes */

public with sharing class CAM_Constants {

    //AM_Asset AM_Status__c values
    public static final String AM_ASSET_STATUS_AVAILABLE = 'Available';
    public static final String AM_ASSET_STATUS_ASSIGNED = 'Assigned';
    public static final String AM_ASSET_STATUS_OUTOFSERVICE = 'OutofService';

    //Constant for AM_Asset__c object type
    public static final String AM_ASSET_API_NAME = 'AgileAssets__AM_Asset__c';

    //Constant for CONTACT object type
    public static final String AM_CONTACT_API_NAME = 'Contact';    

    //Constant for AM_Status__c field name
    public static final String AM_STATUS_API_NAME = 'AgileAssets__AM_Status__c';  
    
    //Constant for Quantity__c field name
    public static final String AM_QUANTITY_API_NAME = 'AgileAssets__Quantity__c';

    //Constant for Case Record Type Name
    public static final String AM_CASE_RT_NAME = 'AM_Asset_Support';  

    //Constant for Dynamic SOQL 
    //'Where'
    public static final String AM_WHERE = String.escapeSingleQuotes('where');
    //'Like'
    public static final String AM_LIKE = String.escapeSingleQuotes('Like');
    //'AND'
    public static final String AM_AND = String.escapeSingleQuotes('AND');
    //'OR'
    public static final String AM_OR = String.escapeSingleQuotes('OR');
    //'SPACE'
    public static final String AM_SPACE = String.escapeSingleQuotes(' ');
}