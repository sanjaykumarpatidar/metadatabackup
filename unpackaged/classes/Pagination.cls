public with sharing class Pagination 
    {

    private set<SC_Order__c> selectedInstruments;
    public list<instrumentlineitem> instrumentlist {get;set;}
    public boolean  search {get;set;}
    private integer size = 10;
    public list<SC_Order__c> finalList = new list<SC_Order__c>();
    public string QueryString  = 'Select Id, Name from SC_Order__c';

    //Standardsetcontroller for the pagiantion
    public ApexPages.Standardsetcontroller standardSetCon {get;set;}
    
    
    //Constructor
    public Pagination()
        {
        instrumentList = new List<instrumentlineitem>();
        selectedInstruments = new set<SC_Order__c>();
        updateStandardSetController();
        }

    //Page method to find the tickets based on the user selected performance.   
    public PageReference FindTickets()
        {
        search = true; 
        QueryString = 'Select Id, Name from SC_Order__c';
        clearList();
        return null;
        }

    //Instantiate the StandardSetController from a query locator
    public void updateStandardSetController()
        {   
        standardSetCon = new ApexPages.StandardSetController(Database.getQueryLocator(QueryString));
        //set the page size to 10
        standardSetCon .setPageSize(size);
        }
    
    //Tickets for selected performance. 
    public List<instrumentlineitem> getPerformanceTickets()
        {
        updateSelectedTickets();
        instrumentlist = new List<instrumentlineitem>();
        //get the records for the StandardSetController
        List<SC_Order__c> instrument = standardSetCon.getRecords();
        for (SC_Order__c i: instrument)
            {
            //check the records if already exsist in the SelectedTicket set.                    
            if(selectedInstruments.contains(i))
                instrumentlist.add(new instrumentlineitem(i,'true'));
            else
                instrumentlist.add(new instrumentlineitem(i));
            }
        return instrumentlist;
        }

    //Reserve the selected tickets
    public void reserve()
        {
        finalList.clear();
        updateSelectedTickets();
        if(!selectedInstruments.isEmpty())   
            {
                system.debug('Selected Instruments - '+selectedInstruments.size());
            }
        }
    
    //Method to the update the selected tickets set based on the user selected. 
    private void updateSelectedTickets()
        {
        for(instrumentlineitem si:instrumentlist)
            {
            if(si.checked)
                selectedinstruments.add(si.instrument);
           else
                {
                if(selectedinstruments.contains(si.instrument))
                    selectedinstruments.remove(si.instrument);
                }
            }
        }


    //Select all method for the "Select All" checkbox
    public boolean selectall
        {
        get { selectall = checklist(); return selectall; } set;
        }

    //Toggle function for select all checkbox.
    public void toggleSelection()
        {
        boolean temp = !selectall;
        for(instrumentlineitem item: instrumentlist)
            {
            item.checked = temp;
            }
        }

    //Check if all the checkboxed are checked.
    public boolean checklist()
        {
        boolean allchecked = true;
        for(instrumentlineitem item: instrumentlist)
            {
            allchecked = allchecked && item.checked;
            }
        return allchecked;
        }

    //Clear all the Lists and Sets.
    public void clearList()
        {
        finalList.clear();
        selectedinstruments.clear();
        instrumentlist.clear();
        updateStandardSetController();
        }
            
    // indicates whether there are more records after the current page set.    
    public Boolean hasNext
        {
        get {
            return standardSetCon.getHasNext();
            }
        set;
        }
    
    // indicates whether there are more records before the current page set.    
    public Boolean hasPrevious
        {
        get {
            return standardSetCon.getHasPrevious();
            }
        set;
        }
  
    // returns the page number of the current page set
    public Integer pageNumber
        {
        get {
            return standardSetCon.getPageNumber();
        }
        set;
        }
  
    // returns the first page of records
    public void first()
        {
        standardSetCon.first();
        }
  
    // returns the last page of records
    public void last()
        {
        standardSetCon.last();
        }
        
    // returns the previous page of records
    public void previous()
        {
        standardSetCon.previous();
        }
  
    // returns the next page of records
    public void next()
        {
        standardSetCon.next();
        }
    
    // returns the total numbe of pages
    public Integer TotalPages
        {
        get
            {   
            if (math.mod(standardSetCon.getResultSize(), size) > 0)
                {
                return standardSetCon.getResultSize()/size + 1;
                } 
            else
                {
                return (standardSetCon.getResultSize()/size);
                }
            }
            set;
        }

//Wrapper Class for the TicketTransaction Class.

public class instrumentlineitem 
    {
    public Boolean checked {get; set;}
    public SC_Order__c instrument {get; set;} 

    //Contructor method. Set the selected value to false
    public instrumentlineitem(SC_Order__c t)
        {
        instrument = t;
        checked = false;
        }

    //Contructor method. Set the selected value to true
    public instrumentlineitem(SC_Order__c t,string s)
        {
        instrument = t;
        checked = true;
        }
    }
            
    }