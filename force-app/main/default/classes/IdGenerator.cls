public inherited sharing class IdGenerator {

    public static String generateRandomAlphanumericId(){
        Integer len = 8;
        Blob blobKey = crypto.generateAesKey(128);
        String key = EncodingUtil.convertToHex(blobKey);
        String generatedId = 'TR' + key.substring(0,len).toUpperCase();
        System.debug('generated id => '+generatedId);

        return generatedId;
    }
}
