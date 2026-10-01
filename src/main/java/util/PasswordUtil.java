package util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.InvalidKeySpecException;
import java.util.Base64;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

/**
 * PasswordUtil - Cryptographic utility for password hashing and verification
 * using PBKDF2WithHmacSHA256 (Password-Based Key Derivation Function 2).
 * Uses standard Java cryptographic APIs (SecretKeyFactory, PBEKeySpec, SecureRandom)
 * without external libraries.
 */
public class PasswordUtil {

    private static final String ALGORITHM = "PBKDF2WithHmacSHA256";
    private static final int SALT_LENGTH = 16; // 16 bytes = 128 bits
    private static final int ITERATIONS = 65536; // 65,536 iterations for strong brute-force resistance
    private static final int KEY_LENGTH = 256; // 256 bits = 32 bytes derived key
    private static final String DELIMITER = ":";

    /**
     * Hashes a plaintext password using PBKDF2WithHmacSHA256 with a unique random salt.
     *
     * @param password the plain text password to hash
     * @return a self-contained string in the format "algorithm:iterations:salt:hash", or null if input is invalid
     */
    public static String hashPassword(String password) {
        if (password == null || password.trim().isEmpty()) {
            return null;
        }

        try {
            // 1. Generate a random 16-byte salt
            SecureRandom random = new SecureRandom();
            byte[] salt = new byte[SALT_LENGTH];
            random.nextBytes(salt);

            // 2. Compute PBKDF2 derived key
            byte[] hash = computePBKDF2(password.toCharArray(), salt, ITERATIONS, KEY_LENGTH);

            // 3. Encode salt and hash into Base64
            String saltBase64 = Base64.getEncoder().encodeToString(salt);
            String hashBase64 = Base64.getEncoder().encodeToString(hash);

            // Format: ALGORITHM:ITERATIONS:SALT:HASH
            return ALGORITHM + DELIMITER + ITERATIONS + DELIMITER + saltBase64 + DELIMITER + hashBase64;
        } catch (NoSuchAlgorithmException | InvalidKeySpecException e) {
            System.err.println("Error hashing password: " + e.getMessage());
            return null;
        }
    }

    /**
     * Verifies whether a candidate plaintext password matches the stored PBKDF2 hash string.
     *
     * @param password candidate plain text password
     * @param storedHash the stored hash in the format "algorithm:iterations:salt:hash"
     * @return true if password matches, false otherwise
     */
    public static boolean verifyPassword(String password, String storedHash) {
        if (password == null || password.trim().isEmpty() || storedHash == null || storedHash.trim().isEmpty()) {
            return false;
        }

        String[] parts = storedHash.split(DELIMITER);
        if (parts.length != 4) {
            return false;
        }

        String algorithm = parts[0];
        if (!ALGORITHM.equalsIgnoreCase(algorithm)) {
            return false;
        }

        try {
            int iterations = Integer.parseInt(parts[1]);
            byte[] salt = Base64.getDecoder().decode(parts[2]);
            byte[] expectedHash = Base64.getDecoder().decode(parts[3]);

            int keyLength = expectedHash.length * 8; // Bit length of the stored hash

            byte[] computedHash = computePBKDF2(password.toCharArray(), salt, iterations, keyLength);

            // Constant-time comparison to guard against timing attacks
            return MessageDigest.isEqual(expectedHash, computedHash);
        } catch (Exception e) {
            System.err.println("Error verifying password: " + e.getMessage());
            return false;
        }
    }

    /**
     * Helper method to compute PBKDF2 hash using SecretKeyFactory.
     */
    private static byte[] computePBKDF2(char[] passwordChars, byte[] salt, int iterations, int keyLength)
            throws NoSuchAlgorithmException, InvalidKeySpecException {
        PBEKeySpec spec = new PBEKeySpec(passwordChars, salt, iterations, keyLength);
        SecretKeyFactory skf = SecretKeyFactory.getInstance(ALGORITHM);
        return skf.generateSecret(spec).getEncoded();
    }
}
