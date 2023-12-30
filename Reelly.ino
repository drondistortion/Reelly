#include <LiquidCrystal_I2C.h> // 1.1.4
#include <Button2.h> // 2.2.4

#define MOTOR_PIN A2

#define BTN_GND 8
#define BTN_BACK 9
#define BTN_PLAY 10
#define BTN_FORW 11
#define NBUTTONS 3

constexpr unsigned NOTCH_DISTANCE = 20;

unsigned g_target_amount = 1000;
unsigned long g_current_amount = 0;

typedef enum {
	MAIN,
	COUNTING
} state_t;

state_t menu_state = MAIN;

Button2 btns[NBUTTONS];

volatile unsigned long g_notch_counter = 0;

LiquidCrystal_I2C disp(0x27, 20, 4);

void setup()
{
	Serial.begin(115200);
	initDisplay();
	initButtons();
	initCounter();
}

void loop()
{
	for (auto& b:btns)
		b.loop();
	handleDisplay();
	handleWinding();
}

void initDisplay()
{
	disp.init();
	//disp.backlight();
	//disp.noBlink();
	disp.print("Start");
	delay(500);
}

void initCounter()
{
	pinMode(2, INPUT);
	attachInterrupt(0, fallingInterrupt, FALLING);
}

void fallingInterrupt()
{
	g_notch_counter++;
}

void initButtons()
{
	pinMode(BTN_GND, OUTPUT);
	digitalWrite(BTN_GND, LOW);

	btns[0].begin(BTN_BACK, INPUT_PULLUP);
	btns[1].begin(BTN_PLAY, INPUT_PULLUP);
	btns[2].begin(BTN_FORW, INPUT_PULLUP);

	for (auto& b:btns) {
		b.setReleasedHandler(btnHandler);
	}
}

void btnHandler(Button2& btn)
{
	switch (btn.getPin()) {
		default: break;
		case BTN_FORW: g_target_amount += 1000; break;
		case BTN_BACK: g_target_amount -= 1000; break;
		case BTN_PLAY: startWinding(); break;
	}

	if (g_target_amount == 0)
		g_target_amount = 1000;
}

void handleDisplay()
{
	static state_t last_state = menu_state;
	if (last_state != menu_state) {
		disp.clear();
		last_state = menu_state;
	}

	if (menu_state == MAIN) {
		printSelection();
	}
	else if (menu_state == COUNTING) {
		printCounting();
	}
}

void printSelection()
{
	disp.setCursor(0,0);
	disp.print("Amount:");
	disp.setCursor(0,1);
	disp.print(g_target_amount);
	disp.print(" mm        ");
}

void printCounting()
{
	disp.setCursor(0,0);
	disp.print("Target: ");
	disp.print(g_target_amount);
	disp.print(" mm");
	disp.setCursor(0,1);
	disp.print("Got: ");
	disp.print(g_current_amount);
	disp.print(" mm        ");
}

void startWinding()
{
	g_notch_counter = 0;
	menu_state = COUNTING;
	startMotor();
}

void handleWinding()
{
	if (menu_state == COUNTING)
		g_current_amount = g_notch_counter*NOTCH_DISTANCE;

	if (g_current_amount+NOTCH_DISTANCE == g_target_amount) {
		g_notch_counter = 0;
		menu_state = MAIN;
		stopWinding();	
	}
}

void stopWinding()
{
	stopMotor();
}

void startMotor()
{
	pinMode(MOTOR_PIN, OUTPUT);
	digitalWrite(MOTOR_PIN, HIGH);
}

void stopMotor()
{
	pinMode(MOTOR_PIN, INPUT);
}
