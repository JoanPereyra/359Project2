/******************************************************************************
 *  From: http://introcs.cs.princeton.edu/java/99crypto/RSA.java.html
 * 
 *  Compilation:  javac RSA.java
 *  Execution:    java RSA N
 *  
 *  Generate an N-bit public and private RSA key and use to encrypt
 *  and decrypt a random message.
 * 
 *  % java RSA 50
 *  public  = 65537
 *  private = 553699199426609
 *  modulus = 825641896390631
 *  message   = 48194775244950
 *  encrypted = 321340212160104
 *  decrypted = 48194775244950
 *
 *  Known bugs (not addressed for simplicity)
 *  -----------------------------------------
 *  - It could be the case that the message >= modulus. To avoid, use
 *    a do-while loop to generate key until modulus happen to be exactly N bits.
 *
 *  - It's possible that gcd(phi, publicKey) != 1 in which case
 *    the key generation fails. This will only happen if phi is a
 *    multiple of 65537. To avoid, use a do-while loop to generate
 *    keys until the gcd is 1.
 *
 ******************************************************************************/

import java.math.BigInteger;
import java.security.SecureRandom;

public class RSA {
   private final static BigInteger ONE      = new BigInteger("1");
   private final static SecureRandom RANDOM = new SecureRandom();

   private BigInteger privateKey;
   private BigInteger publicKey;
   private BigInteger modulus;

   // generate an N-bit (roughly) public and private key
   RSA(int N) {
      BigInteger p = BigInteger.probablePrime(N/2, RANDOM);
      BigInteger q = BigInteger.probablePrime(N/2, RANDOM);
      BigInteger phi = (p.subtract(ONE)).multiply(q.subtract(ONE));

      modulus    = p.multiply(q);               // n                   
      publicKey  = new BigInteger("65537");     // e = 3 or 65537
      privateKey = publicKey.modInverse(phi);   // d
   }
   
   BigInteger encrypt(BigInteger message) {
      return message.modPow(publicKey, modulus);
   }

   BigInteger decrypt(BigInteger encrypted) {
      return encrypted.modPow(privateKey, modulus);
   }

   @Override
   public String toString() {
      String s = "";
      s += "public  = " + publicKey  + "\n";
      s += "private = " + privateKey + "\n";
      s += "modulus = " + modulus;
      return s;
   }
 
   public static void main(String[] args) {
      int N = Integer.parseInt(args[0]);
      RSA key = new RSA(N);
      System.out.println(key);
 
      // create message by converting string to integer
      BigInteger message;
      if(args.length > 1) {
        String s = args[1];
        byte[] bytes = s.getBytes();
        message = new BigInteger(bytes);
      }
      else
        message = new BigInteger(N-1, RANDOM);
      
      BigInteger encrypt = key.encrypt(message);
      BigInteger decrypt = key.decrypt(encrypt);
      System.out.println("message   = " + message);
      System.out.println("encrypted = " + encrypt);
      System.out.println("decrypted = " + decrypt);
   }
}
