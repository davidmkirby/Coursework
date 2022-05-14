import itertools as it
import random as r

letters = list(map(chr, range(65, 91)))
letters.append(' ')

print("\nThis cipher takes the basic Caesar cipher and adds a randomly generated salt of varying length (between 32 & 64 characters). This obfuscates the original plaintext thereby making it slightly more difficult to break.\n")
plaintext = input("Please enter your plaintext: ")
# plaintext = "macaroni"

### Generate salt
salt = ''
random_salt_length = r.randint(32,64)
while len(salt) != random_salt_length:
    salt += r.choice(letters)

### Implement Caesar cipher
spaces_to_shift = 17
shifted_letters = [
    letters[(idx + spaces_to_shift) % len(letters)] 
    for idx, x 
    in enumerate(letters)
]

def encipher_decipher(message, decryption_key, encryption_key):
    upper_plaintext = plaintext.upper()
    upper_salt = salt.upper()
    
    print('\nPlaintext message: {}'.format(''.join(plaintext)))

    ciphertext = [encryption_key[x] for x in upper_salt + upper_plaintext + upper_salt]
    print('Encrypted message: {}'.format(''.join(ciphertext)))

    decrypted_plaintext = [decryption_key[x] for x in ciphertext[len(upper_salt):len(upper_plaintext + upper_salt)]]
    print('Decrypted message: {}\n'.format(''.join(decrypted_plaintext)))

def create_keys(symbols, key_symbols):
    return (
        dict(it.zip_longest(symbols, key_symbols)),
        dict(it.zip_longest(key_symbols, symbols))
    )

encryption_key, decryption_key = create_keys(symbols=letters, key_symbols=shifted_letters)

if __name__ == '__main__':
    encipher_decipher(message=plaintext, decryption_key=decryption_key, encryption_key=encryption_key)