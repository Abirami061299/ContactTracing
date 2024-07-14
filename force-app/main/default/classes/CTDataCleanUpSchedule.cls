public with sharing class CTDataCleanUpSchedule implements schedulable {
    public static String cronExp='0 26 2 * * ?';
    public void execute(SchedulableContext context){
       CTPeopleTracingDataCleanupBatch batchInstance = new CTPeopleTracingDataCleanupBatch();
       Database.executeBatch(batchInstance);
   }
   
//    CTDataCleanUpSchedule schedule=new CTDataCleanUpSchedule();
//    Id id=System.schedule('datacleanup',CTDataCleanUpSchedule.cronExp,schedule);
//    System.debug(id);
}