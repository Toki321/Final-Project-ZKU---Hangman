# Zero knowledge hangman backend (circuits + contracts)

This is the backend for my final project for the zero-knowledge Harmony DAO course.

See front-end implementation here <https://github.com/Toki321/zk-hangman-frontend>.

## Overview

If you've played hangman before, the rules are exactly the same, except with zk-hangman we utilize zero-knowledge proofs and smart contracts to play the game on-chain 
in an entirely trustless manner.

The game consists of two players: the host and the player. The host must initialize the game with the secret 5-10 character word and the player must guess the word 
character by character with a limited number of invalid guesses (which is 6 in our case).

The game starts with the host generating a zk proof from the characters that will make up the word the player will try to guess, and a secret number. We will see why
we need this secret number later. The proof circuit takes in the characters as integers from 0-25 representing each letter of the alphabet from a to z. It then outputs 
the same number character hashes which are hashes of the character (represented as an integer from 0-25) and the secret that the host inputted. It also outputs the hash
of the secret which we will use later. All these hashes are stored on-chain on the smart contract.

It is then the player's turn. The player must submit a character (represented as an integer from 0-25) as their guess. It must be a character that has not been guessed
before. Once the user submits their guess, control is passed to the host to process the guess.

The host processes the guess by submitting a proof that takes in the latest guess by the player as a public input and the secret as a private input. The proof outputs a 
hash of the most recent guess by the player plus the secret and a hash of the secret on its own. By doing so, we can compare the secret hash with the one stored on-chain
to ensure that the host really did use the secret they initially set. We can tell if the guess was valid, by looking at its hash (with the secret) and comparing it to 
all the other character hashes stored on-chain. If the hash matches none of the ones stored on-chain, then we know the guess was invalid and the player's life is 
deducted by one.

The process described above continues until the player has run out of all 6 lives OR the player finally guesses all characters in the word correctly. In the former case 
the host wins; in the latter case the player wins.

## Improvement
My project improves upon the original work here <https://github.com/russel-ra/zk-hangman>. In the prev version game only allowed 5 chars per word because all the inputs in circom need to be fixed length at runtime so I came up with this solution:
First on the front-end User1 inputs a word on the UI
and then clicks submit word. Word length is allowed from 3-10. The mechanic behind it is the 
following: Let’s say User1 inputs 5 letter word and clicks submit word. Now every letter a-z is 
represented 0-25. The remaining 5 letters get filled by the front-end with 26, but they’re not shown in 
the UI. In the UI only 5 dashes will be shown for each letter, but the array is actually 10 
members(letters) long. User1 then initializes game with circuit Init. This circuit takes a signal input 
array with 10 members, which is the first 5 letters (some numbers from 0-25) and the rest are 26 each. 
This is so that the word doesn’t have to be a fixed length of say, 5 letters. This way every time the 
game is played the User1 can choose a 3-10 letter word.
Then User2 submits a guess (1 letter) and User1 processes that as an input in the guess circuit which 
makes sure User1 isn’t cheating by using comparing hashes.
