@isTest
public class TestIdGenerator {
    @isTest public static void testGenerateRandomAlphanumericId(){
        Test.startTest();
        String Id = IdGenerator.generateRandomAlphanumericId();
        Test.stopTest();

        System.assert(Id.contains('TR'), 'Should generate Id with prefix "TR"');
    }
}
