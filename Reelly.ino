#include <LiquidCrystal_I2C.h>

#define OPTO_LED 10

volatile unsigned long notch_counter = 0;

LiquidCrystal_I2C disp(0x27, 20, 4);

void setup()
{
	Serial.begin(115200);
	initDisplay();
	initOpto();
	initCounter();
}

void loop()
{
	disp.setCursor(0,0);
	disp.print("Got: ");
	disp.print((float)notch_counter*0.02, 2);
	disp.print(" Meters");
}

void initDisplay()
{
	disp.init();
	disp.backlight();
	disp.noBlink();
	disp.print("Start");
	delay(500);
}

void initOpto()
{
	pinMode(OPTO_LED, OUTPUT);
	digitalWrite(OPTO_LED, HIGH);
}

void initCounter()
{
	pinMode(2, INPUT);
	attachInterrupt(0, fallingInterrupt, FALLING);
}

void fallingInterrupt()
{
	notch_counter++;
}

