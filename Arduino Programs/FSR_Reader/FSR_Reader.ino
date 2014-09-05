int FSR_Pin = A0; //analog pin 0

void setup(){
  Serial.begin(9600);
}

void loop(){
  int FSRReading = analogRead(FSR_Pin); 

  Serial.println(FSRReading);
  delay(200); //just here to slow down the output for easier reading
}
