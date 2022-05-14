# This is an implementation of the Output Feedback mode which sends the enciphered
# IV output as feedback for subsequent slices. This means the IV gets re-enciphered
# each slice and does not get used twice. Referenced block diagram show here:
# https://media.geeksforgeeks.org/wp-content/uploads/output-feedback-mode.png

import simple_ciphers as sc

def apply_cipher(cipher, plaintext, iv=''):
    plaintext = plaintext.upper().strip().replace(' ', '')
    
    
    slices = [plaintext[i:i+5] for i in range(0, len(plaintext), 5)]
    slices = [slice if len(slice) == 5 else slice + 'X' * (5 - len(slice)) for slice in slices]
    
    # Encipher the IV and use it as feedback for the next slice
    enciphered_iv = cipher.encipher(iv.upper())
    
    # Encipher the plaintext block with the ciphered IV so that essentially the IV is
    # re-enciphered each time and never use the same IV twice.
    enciphered_slices = [cipher.encipher(sc.Vigenere(enciphered_iv).encipher(slice)) for slice in slices]
    
    print('<=== ({})'.format(type(cipher)))
    print('Blocked ciphertext\t {}'.format(''.join(enciphered_slices)))
    print('Non-blocked ciphertext\t {}'.format(cipher.encipher(plaintext)))
    print('===>')


plaintext = 'This is a sooper sekkrit message'
vigenere = sc.Vigenere('iskey')
bifid = sc.Bifid()

if __name__ == '__main__':
    print('\nThis is an implementation of the Output Feedback mode which sends the enciphered IV output as feedback for subsequent slices. This means the IV gets re-enciphered each slice and does not get used twice. Referenced block diagram show here: https://media.geeksforgeeks.org/wp-content/uploads/output-feedback-mode.png\n')

    iv = 'ab'
    apply_cipher(cipher=vigenere, plaintext=plaintext, iv=iv)
    apply_cipher(cipher=bifid, plaintext=plaintext, iv=iv)

    iv = 'cd'
    apply_cipher(cipher=vigenere, plaintext=plaintext, iv=iv)
    apply_cipher(cipher=bifid, plaintext=plaintext, iv=iv)