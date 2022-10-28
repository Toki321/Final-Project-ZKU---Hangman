pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/mimcsponge.circom";
include "../node_modules/circomlib/circuits/comparators.circom";

template init() {
    signal input secret;
    signal input char[10];

    signal output secretHash;
    signal output charHash[10];

    component leqt[10]; 
    component geqt[10];

    // characters are represented as digits between 0-25 inclusive, 26 means no character there

    for (var i = 0; i < 10; i++) {
        leqt[i] = LessEqThan(32);
        leqt[i].in[0] <== char[i];
        leqt[i].in[1] <== 26; 

        leqt[i].out === 1;

        geqt[i] = GreaterEqThan(32);
        geqt[i].in[0] <== char[i];
        geqt[i].in[1] <== 0; 

        geqt[i].out === 1;
    }

    // calculate secret hash

    component mimcSecret = MiMCSponge(1, 220, 1);

    mimcSecret.ins[0] <== secret;
    mimcSecret.k <== 0;

    secretHash <== mimcSecret.outs[0];

    // calculate character hashes

    component charMimc[10];

    for (var i = 0; i < 10; i++) {
        charMimc[i] = MiMCSponge(2, 220, 1);

        charMimc[i].ins[0] <== char[i];
        charMimc[i].ins[1] <== secret;
        charMimc[i].k <== 0;
        
        charHash[i] <== charMimc[i].outs[0];
    }

}

component main = init();