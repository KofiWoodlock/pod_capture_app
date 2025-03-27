// Module for helper functions that will be used throughout the app
// ignore_for_file: non_constant_identifier_names

import 'dart:math';

class Encrypt {}

class SHA256 {

  // CONSTANTS
  // These values are the first 32 bits of the fractional parts of the square roots of the first 8 primes
  static final List<int> H = [
    0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a,
    0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19
  ];

  // These values are the first 32 bits of the fractional parts of the cubic roots of the first 64 prime numbers
  static final List<int> K = [
    0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5,
    0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
    0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3,
    0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
    0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc,
    0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
    0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7,
    0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
    0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13,
    0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
    0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3,
    0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
    0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5,
    0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
    0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208,
    0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2
  ];

  // UTILITY FUNCTIONS 

  static List<int> translate(String message) {
    """ Converts a string to a list of bits """;

    List<int> bits = [];
    // convert each character in string to unicode equivilant
    for (int charCode in message.codeUnits) {
    // convert unicode values to 8-bit strings 
    // padleft is used to pads the string with zeros until it reaches length of 8
      String binary = charCode.toRadixString(2).padLeft(8, '0');
      // Convert 8-bit strings to list of bits as integers 
      bits.addAll(binary.split('').map((bit) => int.parse(bit)));
    }
    return bits;
  }

  static String binaryToHex(List<int> bits) {
    """ Converts a list of bits to hexadecimal notation """;

    // Convert list to string 
    String binaryString = bits.join();

    // split string of bits into nibbles (chunks of 4 bits)
    // add a binary string indicator '0b'
    StringBuffer hexBuffer = StringBuffer();
    for (int i = 0; i < binaryString.length; i += 4) {
      String nibble = binaryString.substring(i, min(i + 4, binaryString.length)).padLeft(4, '0');
      // convert to hexadecimal  
      hexBuffer.write(int.parse(nibble, radix: 2).toRadixString(16));
    }
    return hexBuffer.toString();
  }

  static List<int> fillZeros(List<int> bits, {int length = 8, String endian = 'LE'}) {
    """ Pads out a list of bits with zeros until specified length is met """;

    while (bits.length < length) 
    // Endianness describes the order in which bytes are arranged in computer memory
    // two main types: big-endian (where the most significant byte comes first) 
    // and little-endian (where the least significant byte comes first)
    {
      if (endian == 'LE') {
        bits.add(0);
      } else {
        bits.insert(0, 0);
      }
    }
    return bits;
  }

  static List<List<int>> partition(List<int> bits, {int wordLength = 8}) {
    """ Divides a list of bits into desired word length starting at LSB """;

    List<List<int>> chunks = [];
    for (int i = 0; i < bits.length; i += wordLength) {
      chunks.add(bits.sublist(i, min(i + wordLength, bits.length)));
    }
    return chunks;
  }

  static List<List<int>> initialiser(List<int> values) {
    """ Convert constants from hex to binary string removing '0b' prefix """;

    List<List<int>> words = [];
    for (int val in values) {
      String binary = val.toRadixString(2).padLeft(32, '0');
      // Convert from string to a list of 32 bit lists (2D array)
      List<int> word = binary.split('').map((bit) => int.parse(bit)).toList();
      words.add(fillZeros(word, length: 32, endian: 'BE'));
    }
    return words;
  }

  static List<List<int>> preprocessMessage(String message) {
    """ Pads the input message to ensure length is a multiple of 512 """;

    // convert string message to bits
    List<int> bits = translate(message);
    
    //get message length 
    int length = bits.length;

    // get length of message as 64 bit blocks 
    List<int> length64 = int.parse(length.toRadixString(2)).toString().padLeft(64, '0').split('').map((bit) => int.parse(bit)).toList();

    /* Three main cases:
      if length is less than 448, handle the block individually 
      if length between 449 and 512 inclusive, then append a single 1 and pad to next multiple of 512
      if length is greater than 448, create a multiple of 512
      adding 64 bits at end representing length of message
    */

    if (length < 448) {
      // append 1 
      bits.add(1);
      // fill zeros little endian wise
      bits = fillZeros(bits, length: 448, endian: 'LE');
      bits.addAll(length64);
      // return as a list
      return [bits];
    } else if (length >= 448 && length <= 512) {
      bits.add(1);
      // Move to the next message block totalling the length to 1024
      bits = fillZeros(bits, length: 1024, endian: 'LE');
      // Replace the last 64 bits of the mutliple of 512 with the 64 bits representing message length
      bits.replaceRange(bits.length - 64, bits.length, length64);
      // Return it as 512 bit chuncks  
      return partition(bits, wordLength: 512);
    } else {
      // if message length exceeds 448 loop until multiple of 512 + 64
      bits.add(1);
      while ((bits.length + 64) % 512 != 0) {
        bits.add(0);
      }
      // Add 64 bits representing message length 
      bits.addAll(length64);
      // Return it as 512 bit chunks
      return partition(bits, wordLength: 512);
    }
  }


  // HASH ALGORITHM FUNCTIONS

  // boolean check to see if integer is 1
  static bool isTrue(int x) => x == 1;
  // Custom if
  static int if_(int i, int y, int z) => isTrue(i) ? y : z;
  
  // AND logic gate - both arguments must be true 
  static int and_(int i, int j) => if_(i, j, 0);
  static List<int> AND(List<int> i, List<int> j) => List.generate(i.length, (index) => and_(i[index], j[index]));

  // NOT logic gate - negates any argument 
  static int not_(int i) => if_(i, 0, 1);
  static List<int> NOT(List<int> i) => i.map((x) => not_(x)).toList();

  // XOR - either argument may be true but not both or neither 
  static int xor(int i, int j) => if_(i, not_(j), j);
  static List<int> XOR(List<int> i, List<int> j) => List.generate(i.length, (index) => xor(i[index], j[index]));

  // if number of true values is odd return true 
  static int xorxor(int i, int j, int l) => xor(i, xor(j, l));
  static List<int> XORXOR(List<int> i, List<int> j, List<int> l) => List.generate(i.length, (index) => xorxor(i[index], j[index], l[index]));
  
  // Get majority of results e.g. if 2 of three values are true then return true
  static int majority(int i, int j, int k) {
    List<int> values = [i, j, k];
    return values.reduce((a, b) => values.where((x) => x == a).length > values.where((x) => x == b).length ? a : b);
  }

  // Rotates a binary string x numbers of times to the right wrapping values around once they reach the end
  static List<int> rotr(List<int> x, int n) {
    return [...x.sublist(x.length - n), ...x.sublist(0, x.length - n)];
  }

  // Logical shift right 
  static List<int> lsr(List<int> x, int n) {
    return List.filled(n, 0) + x.sublist(0, x.length - n);
  }
  
  // FULL ADDER

  static List<int> add(List<int> i, List<int> j) {
    """ Takes list of binary numbers and performs binary addition """;

    List<int> sums = List.filled(i.length, 0);
    // Initialise carry as 0 
    int c = 0;
    for (int x = i.length - 1; x >= 0; x--) {
      // Add bits using double xor gate 
      sums[x] = xorxor(i[x], j[x], c);
      /* carry bit is represented as the majority bit
        if output = 0, 1, 0 then carry will be 0 */
      c = majority(i[x], j[x], c);
    }
    // return list of bits
    return sums;
  }

  // Main SHA-256 Hash Function
  static String hash(String message) {
    List<List<int>> k = initialiser(K);
    List<List<int>> hInitial = initialiser(H);
    
    List<List<int>> h = [
      hInitial[0], hInitial[1], hInitial[2], hInitial[3],
      hInitial[4], hInitial[5], hInitial[6], hInitial[7]
    ];
    
    List<List<int>> chunks = preprocessMessage(message);
    
    for (var chunk in chunks) {
      List<List<int>> w = partition(chunk, wordLength: 32);
      w.addAll(List.generate(48, (_) => List.filled(32, 0)));
      
      for (int i = 16; i < 64; i++) {
        List<int> s0 = XORXOR(rotr(w[i-15], 7), rotr(w[i-15], 18), lsr(w[i-15], 3));
        List<int> s1 = XORXOR(rotr(w[i-2], 17), rotr(w[i-2], 19), lsr(w[i-2], 10));
        w[i] = add(add(add(w[i-16], s0), w[i-7]), s1);
      }
      
      List<int> a = h[0];
      List<int> b = h[1];
      List<int> c = h[2];
      List<int> d = h[3];
      List<int> e = h[4];
      List<int> f = h[5];
      List<int> g = h[6];
      List<int> hh = h[7];
      
      for (int j = 0; j < 64; j++) {
        List<int> S1 = XORXOR(rotr(e, 6), rotr(e, 11), rotr(e, 25));
        List<int> ch = XOR(AND(e, f), AND(NOT(e), g));
        List<int> temp1 = add(add(add(add(hh, S1), ch), k[j]), w[j]);
        List<int> S0 = XORXOR(rotr(a, 2), rotr(a, 13), rotr(a, 22));
        List<int> m = XORXOR(AND(a, b), AND(a, c), AND(b, c));
        List<int> temp2 = add(S0, m);
        
        hh = g;
        g = f;
        f = e;
        e = add(d, temp1);
        d = c;
        c = b;
        b = a;
        a = add(temp1, temp2);
      }
      
      h[0] = add(h[0], a);
      h[1] = add(h[1], b);
      h[2] = add(h[2], c);
      h[3] = add(h[3], d);
      h[4] = add(h[4], e);
      h[5] = add(h[5], f);
      h[6] = add(h[6], g);
      h[7] = add(h[7], hh);
    }
    
    StringBuffer digest = StringBuffer();
    for (var val in h) {
      digest.write(binaryToHex(val));
    }
    
    return digest.toString();
  }
}

