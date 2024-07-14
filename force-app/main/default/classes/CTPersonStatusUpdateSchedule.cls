public with sharing class CTPersonStatusUpdateSchedule implements schedulable {
    public static String cronExp='0 33 3 * * ?';
    public void execute(SchedulableContext context){
        CTPersonStatusUpdateBatch batchInstance = new CTPersonStatusUpdateBatch();
        Database.executeBatch(batchInstance);
   }
}