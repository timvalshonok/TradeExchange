@isTest
public class IdGeneratorTest {
    @isTest public static void generateRandomAlphanumericIdTest() {
        Test.startTest();
        String Id = IdGenerator.generateRandomAlphanumericId();
        Test.stopTest();

        System.assert(Id.contains('TR'), 'Should generate Id with prefix "TR"');
    }
}
