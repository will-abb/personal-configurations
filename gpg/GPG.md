## Using GPG with Subkeys

When using GPG for encryption and decryption with YubiKeys, you may not be able to successfully specify the recipient as an email address. This is because the YubiKey uses subkeys rather than the master key, and you may not be able to decrypt using email addresses. Instead, you must use the actual key IDs for encryption and decryption.

### Key Selection for Encryption and Decryption
1. **Encrypt** using the public key of your YubiKey Nano:
   ```bash
   gpg --recipient F354D41FEAA5B93A7F66947ACA0B193EEF9607A8 --encrypt file.txt
   ```
2. **Decrypt** as usual:
   ```bash
   gpg --decrypt file.gpg > output.txt
   ```
---

### Commands

#### **1. Encrypting with a Key ID**
To encrypt a file using a specific key ID:
```bash
gpg --recipient KEYID --encrypt file.txt
```

#### **2. Encrypting with a Username**
To encrypt a file using the username associated with the key:
- **Personal use** (replace `User Personal` with your actual name):
  ```bash
  gpg --recipient "User Personal" --encrypt file.txt
  ```

#### **3. Decrypting Files**
Decryption does not require specifying a recipient, as GPG will automatically use the private key matching the public key used for encryption:
```bash
gpg --decrypt file.gpg
```

#### **4. Deleting All Keys**
To delete all keys (both secret and public):
```bash
gpg --delete-secret-and-public-keys '*'
```

#### **5. Encrypt/Decrypt with YubiKey Nano**
- **Encrypt:**
  Use `epa-encrypt-region` and select the region to encrypt. Ensure you specify the correct key.
- **Decrypt:**
  Use `epa-decrypt-region`. When prompted for a PIN, provide the GPG user PIN (not the YubiKey admin PIN). Ensure you select the entire encrypted block to avoid errors.

---

### Notes
- You can configure your YubiKey to require touch for any operation, such as encryption or decryption, or to allow these operations without touch, depending on your preferences.
- If you encounter issues with `gpg --card-edit` or `gpg --card-status`, try restarting the card service:
  ```bash
 sudo systemctl restart pcscd && sleep 2 && gpg --card-status sudo systemctl restart pcscd
  ```

---

## Using GPG to Sign Commits with a YubiKey

### 1. Prepare the Keys
- Import both your **public** and **private** keys if they are not already in your GPG keyring:
  ```bash
  gpg --import <path-to-public-key-file>
  gpg --import <path-to-private-key-file>
  ```
- If Bitbucket denies your key due to a missing email, add a UID to the **master key**:
  ```bash
  gpg --edit-key <key-id>
  adduid
  save
  ```
- After importing and modifying, delete the private key from your keyring:
  ```bash
  gpg --delete-secret-keys <key-id>
  ```

### 2. Specify the Signature Key
Configure Git to use the **signing subkey** (not the master key) for commits:
```bash
git config --global user.signingkey <signing-subkey-id>
git config --global commit.gpgsign true
```

### 3. Verify Public Key Availability
Ensure the public key is in your keyring:
```bash
gpg --list-keys
```

---

### Key Notes
- The **public key** must remain in your keyring; the YubiKey does not provide it.
- Always use the **signing subkey** for commits, not the master key.
- If modifications to the key are needed (e.g., adding a UID), temporarily import the private key, make the changes, and delete it again afterward.
-  You can generate sub-keys with this [gpg-generate-key-and-subkeys.yaml](gpg-generate-key-and-subkeys.yaml)
