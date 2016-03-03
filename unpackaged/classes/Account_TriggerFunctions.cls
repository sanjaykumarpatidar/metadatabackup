public class Account_TriggerFunctions {
    public static void checkGermanUser(List<Account> newTrigger ,Map<Id, Account> mapOldAccount ) {
        string objectName = 'Account';
        Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap();
        list<string> selectFields = new list<string>();
        string userCountry = [select local_country__c from User where id = :UserInfo.getUserId()].local_country__c;
        if(userCountry == 'Germany') {
            if (fMap != null) {
                for (Schema.SObjectField ft : fMap.values()) { // loop through all field tokens (ft)
                    Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
                    system.debug('Field Details - '+fd);
                    if (fd.isUpdateable()) { // field is updatable
                        selectFields.add(fd.getName());
                    }
                }
            }
            
            /* to be done
            * remove the fields he can edit
            */
            
            for(Account newrec : newTrigger) {
                Account oldrec = mapOldAccount.get(newrec.Id);
                //iterate over fields this user cannot edit.
                for (string fieldName : selectFields) {
                    if(newRec.get(fieldName)!=oldRec.get(fieldName)) {
                        newrec.Name.addError('You do not have permissions to Edit this Account');
                        break;
                    }
                }
            }
        }
    }
}