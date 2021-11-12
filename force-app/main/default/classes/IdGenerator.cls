public inherited sharing class IdGenerator {

    public static String generateRandomAlphanumericId() {
        Integer length = 8;
        Blob blobKey = crypto.generateAesKey(128);
        String key = EncodingUtil.convertToHex(blobKey);
        String generatedId = 'TR' + key.substring(0,length).toUpperCase();

        return generatedId;
    }
}
