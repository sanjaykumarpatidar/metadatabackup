trigger AccountTrigger on Account (Before Update) {
    if(trigger.isBefore && trigger.isUpdate) {
        Account_TriggerFunctions.checkGermanUser(Trigger.new, Trigger.oldMap);
    }        
}