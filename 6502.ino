const char ADDR[] = {22, 24, 26, 28, 30, 32, 34, 36, 38, 40, 42, 44, 46, 48, 50, 52};
const char DATA[] = {39, 41, 43, 45, 47, 49, 51, 53};
#define CLOCK 2
#define READ_WRITE 3


void setup() {
  for (int i = 0; i < 16; i+=1) {
    pinMode(ADDR[i], INPUT);  
  }

  for (int i = 0; i < 8; i+=1) {
    pinMode(DATA[i], INPUT);  
  }

  pinMode(CLOCK, INPUT);
  
  pinMode(READ_WRITE, INPUT);

  attachInterrupt(digitalPinToInterrupt(CLOCK), onClock, RISING);
  
  Serial.begin(57600); 
}


void onClock() {
  unsigned int address = 0;
  unsigned int data = 0;
  char output[15];  

  for (int i = 0; i < 16; i+=1) {
    int bit = digitalRead(ADDR[i]) ? 1 : 0;
    Serial.print(bit);
    address = (address << 1) + bit;
  }
  
  Serial.print("    ");
  
  for (int j = 0; j < 8; j+=1) {
    int databit = digitalRead(DATA[j]) ? 1 : 0;
    Serial.print(databit);
    data = (data << 1) + databit;
  }

  sprintf(output, "   %04x %c %02x", address, digitalRead(READ_WRITE) ? 'r' : 'W', data );
  
  Serial.println(output);
}

void loop() {
}
