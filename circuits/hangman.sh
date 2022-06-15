# Compiling our circuit
circom hangman.circom --r1cs --wasm --sym

# Computing the witness with WebAssembly
node ./hangman_js/generate_witness.js ./hangman_js/hangman.wasm input_hangman.json ./hangman_js/witness.wtns

# # Powers of Tau
snarkjs powersoftau new bn128 12 pot12_0000.ptau -v
snarkjs powersoftau contribute pot12_0000.ptau pot12_0001.ptau --name="First contribution" -e="random"


# # Phase 2
snarkjs powersoftau prepare phase2 pot12_0001.ptau pot12_final.ptau -v
snarkjs groth16 setup hangman.r1cs pot12_final.ptau hangman_0000.zkey
snarkjs zkey contribute hangman_0000.zkey hangman_0001.zkey --name="1st Contributor Name" -e="random"

# Export the verification key:
snarkjs zkey export verificationkey hangman_0001.zkey verification_key.json


# Generating a Proof
snarkjs groth16 prove hangman_0001.zkey ./hangman_js/witness.wtns hangman_proof.json public.json


# Verifying a Proof
snarkjs groth16 verify verification_key.json public.json hangman_proof.json

# Verifying from a Smart Contract
snarkjs zkey export solidityverifier hangman_0001.zkey ../contracts/verifier.sol
# https://stackoverflow.com/questions/25486667/sed-without-backup-file
sed -i '' -e 's/0\.6\.11/0\.8\.0/' ../contracts/verifier.sol

# snarkjs generatecall | tee parameters.txt