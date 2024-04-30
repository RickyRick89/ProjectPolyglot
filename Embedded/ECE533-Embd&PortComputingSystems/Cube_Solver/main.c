// Includes ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#include <main.h>
#include <stdbool.h>
#include <math.h>
#include <string.h>
#include <stm32l552xx.h>
#include <stdio.h>
#include <stdlib.h>
#include <float.h>

// Type Definitions ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
typedef struct {
    uint8_t r;
    uint8_t g;
    uint8_t b;
} Color;
typedef struct {
    float h; // Hue, range: 0-360 degrees
    float s; // Saturation, range: 0-1
    float v; // Value, range: 0-1
} HSV;
typedef struct {
	uint8_t v1;
	uint8_t v2;
	uint8_t v3;
	uint8_t v4;
	uint8_t v5;
	uint8_t r1;
	uint8_t r2;
	uint8_t r3;
	uint8_t r4;
	uint8_t l1;
	uint8_t l2;
	uint8_t l3;
	uint8_t l4;
} Eval_Codes;
typedef struct {
	uint8_t up[3][3];    // Up face
	uint8_t front[3][3]; // Front face
	uint8_t right[3][3]; // Right face
	uint8_t back[3][3];  // Back face
	uint8_t down[3][3];  // Down face
	uint8_t left[3][3];  // Left face
} RubiksCube;
// Define function pointer type
typedef void (*functionPointer)();
typedef struct menuitem menuitem;
// Define menu struct
struct menuitem {
	const char *name;
    menuitem *parent; // pointer to parent menu
    menuitem **menuitems; // array of menu items, NULL terminated
    functionPointer handler; // handler for this node (optionally null)
};

// Defining main menu //
menuitem* mainMenu;
//// submenus ////
// help menu //
menuitem* helpMenu;
// motor menu //
menuitem* motorOptions;
	// motor submenus
	menuitem* motorRight;
	menuitem* motorLeft;
	menuitem* motorUp;
	menuitem* motorDown;
	menuitem* motorFront;
	menuitem* motorBack;
// auto menu //
menuitem* autoMenu;
	// auto submenus
	menuitem* autoMenu2;



// Some helper macros ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#define bitset(word,   idx)  ((word) |=  (1<<(idx))) //Sets the bit number <idx> -- All other bits are not affected.
#define bitclear(word, idx)  ((word) &= ~(1<<(idx))) //Clears the bit number <idx> -- All other bits are not affected.
#define bitflip(word,  idx)  ((word) ^=  (1<<(idx))) //Flips the bit number <idx> -- All other bits are not affected.
#define bitcheck(word, idx)  ((word>>idx) &   1   ) //Checks the bit number <idx> -- 0 means clear; !0 means set.
#define ConcatenateWords(word1, word2) (((uint16_t)(word1) << 8) | (word2))//concat two 8bit words to 1 16bit.


//Pre-Declarations of functions. Full declarations are after main(). ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Config and Init
void configGPIOD();
void InitGPIOE();
void InitGPIOG();
void setClks();
void InitCamera();
void InitSPI();
//Image Processing
void normalize(float rgb[3]);
HSV rgb_to_hsv(int r, int g, int b);
Color find_closest_hsv_color(uint8_t r, uint8_t g, uint8_t b);
void TakePic(uint8_t* image);
Color convertRGB565toRGB888(uint16_t rgb565);
void image_color_classify(uint8_t* image, uint8_t* classified_image, Eval_Codes* codes);
int find_color_index(uint8_t r, uint8_t g, uint8_t b);
uint8_t get_majority_color(uint8_t* classified_image, int x, int y);
//Cube Solving
void Cube_Eval(uint8_t* image, uint8_t* classified_image, RubiksCube* cube);
void sendCube(RubiksCube *cube);
//COMMS
void WriteSPI(uint8_t addr, uint8_t* data, uint16_t length);
void ReadSPI(uint8_t addr, uint8_t* data, uint16_t length, bool immediate);
uint8_t ReadSPIByte(uint8_t addr);
void InitLPUART1(uint32_t baud, uint8_t stop, uint8_t data_len, bool parity_en, bool parity_odd);
void LPUART1_IRQHandler();
void clearbufs();
void transmitBufData(char msg[]);
void initUART4(uint8_t data_bits, uint8_t stop_bits, bool parity, bool par_type,
			   uint16_t bd_rate);
void sendDataUART4(char data);
//Misc
void delay_ms(uint32_t val); // Using SysTick with 16Mhz source clock
//Motor Control
void motorControl(uint8_t moveCode, uint16_t speed);
void turnMotorx(bool direction, uint8_t degrees, uint8_t step_pin, uint8_t dir_pin, uint16_t speed);
void motorxHandler(menuitem* motor);
void TIM3_freq(uint16_t val);
//LCD-related functions
void initMenus(); // defined in LCD Menu
void HelpMenu();
void MenuOptions();
void cursorControl(char *strIn);
void initInputButtons();
void initScreen();
void writeScreen(char *str1, char *str2);


// Global Constants ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//LPUART Constants
#define BUFFER_SIZE                   				200              // Size of the buffer used for RX and TX operations.
//Camera Constants
#define CAM_REG_FRAME_NUM	                      	0x01
#define CAM_REG_POWER_CONTROL                      	0x02
#define CAM_REG_MEM_CNTRL	                    	0x04
#define CAM_REG_DATA_CNTRL	                    	0x05
#define CAM_REG_SENSOR_RESET                       	0x07
#define CAM_REG_FORMAT                             	0x20
#define CAM_REG_CAPTURE_RESOLUTION                 	0x21
#define CAM_REG_BRIGHTNESS_CONTROL                 	0x22
#define CAM_REG_CONTRAST_CONTROL                   	0x23
#define CAM_REG_SATURATION_CONTROL                 	0x24
#define CAM_REG_EV_CONTROL                         	0x25
#define CAM_REG_WHILEBALANCE_MODE_CONTROL          	0x26
#define CAM_REG_COLOR_EFFECT_CONTROL               	0x27
#define CAM_REG_SHARPNESS_CONTROL                  	0x28
#define CAM_REG_AUTO_FOCUS_CONTROL                 	0x29
#define CAM_REG_IMAGE_QUALITY                      	0x2A
#define CAM_REG_EXPOSURE_GAIN_WHILEBALANCE_CONTROL 	0x30
#define CAM_REG_MANUAL_GAIN_BIT_9_8                	0x31
#define CAM_REG_MANUAL_GAIN_BIT_7_0                	0x32
#define CAM_REG_MANUAL_EXPOSURE_BIT_19_16          	0x33
#define CAM_REG_MANUAL_EXPOSURE_BIT_15_8           	0x34
#define CAM_REG_MANUAL_EXPOSURE_BIT_7_0            	0x35
#define CAM_REG_BURST_FIFO_READ_OPERATION          	0x3C
#define CAM_REG_SINGLE_FIFO_READ_OPERATION         	0x3D
#define CAM_REG_SENSOR_ID                          	0x40
#define CAM_REG_YEAR_ID                            	0x41
#define CAM_REG_MONTH_ID                           	0x42
#define CAM_REG_DAY_ID                             	0x43
#define CAM_REG_SENSOR_STATE                       	0x44
#define CAM_REG_FPGA_VERSION_NUMBER                	0x49

//Motor constants
#define DEFAULT_MOTOR_SPEED 	((uint16_t) 800)
#define INSPECTION_MOTOR_SPEED	((uint16_t) 1200)
#define D0 	0
#define D1 	1
#define D2 	2
#define D3 	3
#define D4 	4
#define D5 	5
#define D6 	6
#define D7 	7
#define D8 	8
#define D9 	9
#define D11 11
#define D12 12

//LCD constants
#define LCD_START_COMMAND 0xfe
#define LCD_NEW_LINE 	  0x0d
#define LCD_DEL 		  0x08
#define LCD_CLEAR 		  0x58
#define LCD_CUR_ON 		  0x4a
#define LCD_CUR_OFF 	  0x4b
#define LCD_BCUR_ON		  0x53
#define LCD_BCUR_OFF	  0x54
#define LCD_CUR_HOME	  0x48
#define LCD_CUR_BACK	  0x4c
#define LCD_CUR_FORW	  0x4d
#define LCD_AUTO_SCR	  0x51
#define LCD_STRT_SCR	  0x40
#define LCD_STR_LEN 	  16
#define NUM_MAIN_MENU_OPTIONS 3
#define NUM_HELP_OPTIONS 9
#define NUM_MOTOR_OPTIONS 6
#define NUM_AUTO_OPTIONS 2

//Global Variables ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
uint32_t    timeoutCounter = 0;    	// Counter for managing operation timeouts.
uint8_t     rxBuffer[BUFFER_SIZE]; 	// Buffer to store received data before processing or EEPROM storage.
uint8_t     bufferIndex = 0;       	// Index to track the current position
int 		count = 0; 				// count of steps
int 		steps = 0; 				// number of steps needed for the desired deg of rotation
uint8_t 	stepper_pin; 			// stepper motor pulse pin
uint8_t 	direction_pin; 			// stepper motor direction pin
bool 		dir; 					// direction
bool 		moveComplete = true; 	// movement motion is done
char 		buf1[17];
char 		buf2[17];
int menuCount = 0;
int motorCount = 0;
uint8_t buttons 	= 0;
uint16_t state		= 0;
uint8_t motorStates = 0;
bool menuStart = true;
Color colors[] = {
	{83, 8, 8},   	  // red
    {104, 253, 120},  // green
    {48, 133, 221},   // blue
    {209, 252, 120},  // yellow
    {189, 52, 0}, 	  // orange
    {255, 255, 255}   // white
};
Color pure_colors[] = {
    {255, 0, 0},     // red
    {0, 255, 0},     // green
    {0, 0, 255},     // blue
    {255, 255, 0},   // yellow
    {255, 165, 0},   // orange
    {255, 255, 255}  // white
};

/* Color Codes ~~~~~~~~~~~
 *  1: 'white',
 *  3: 'red',
 *  2: 'green',
 *  4: 'blue',
 *  5: 'yellow',
 *  6: 'orange'*/
uint8_t color_codes[] = {3, 2, 4, 5, 6, 1};




int main(){
	//Variable Declarations ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	uint8_t image[27648];	//pixel array. 96x96x3
	uint8_t classified_image[27648];	//pixel array. 96x96x3
	RubiksCube cube = {0};
	uint8_t buffer_pntr = 0;
	Eval_Codes sticker_codes = {0};

	cube.left[1][1] = 6;
	cube.right[1][1] = 3;
	cube.up[1][1] = 1;
	cube.down[1][1] = 5;
	cube.front[1][1] = 2;
	cube.back[1][1] = 4;

    memset(image, 0, sizeof(image));

	//Configure Clocks/Timers ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	bitset(RCC->CFGR, 0);     // Use HSI16 as SYSCLK
	setClks();

	//Configure GPIOs ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	configGPIOD();
	InitGPIOE();
	InitGPIOG();


	// Setup Interrupt Priority
	NVIC_SetPriority(TIM3_IRQn, 0);
	// Enable IRQ in NVIC
	NVIC_EnableIRQ(TIM3_IRQn);




	//Configure Comms ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	InitLPUART1(115200,1,8,false,false);	//InitLPUART1(baud, stop, data_len, parity_en, parity_odd)
	initUART4(8, 1, false, false, 9600);	//initUART4(uint8_t data_bits, uint8_t stop_bits, bool parity, bool par_type, uint16_t bd_rate);
	InitSPI();

	// Configure/Init Peripherals ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	// clear screen
	sendDataUART4(LCD_START_COMMAND);
	sendDataUART4(LCD_CLEAR);
	// Menu Setup
	initScreen();
	initMenus();
	initInputButtons();
	// Welcome screen
	mainMenu->handler("Welcome to Rubik","Cube Solver Menu");
	sendDataUART4(LCD_START_COMMAND);
	sendDataUART4(LCD_BCUR_ON);
	InitCamera();





	//Infinite Loop ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	while(1){

	    if (timeoutCounter > 0){
	        timeoutCounter--;               // Decrement the timeout counter each cycle.
	    } else if (timeoutCounter == 0 && bufferIndex > 0 && moveComplete) { // Check if timeout has occurred and there is data in the buffer.
	    	uint8_t MoveCode = 255;

	    	switch (rxBuffer[buffer_pntr]){
			case 'I': // Get Image
				TakePic(image);
				for (uint16_t i = 0; i < 27648; i ++) {
					while ((bitcheck(LPUART1->ISR, 7) == 0));
					LPUART1->TDR = image[i];
				}
				break;
			case 'i': // Get Image
				TakePic(image);
				for (uint16_t i = 0; i < 27648; i ++) {
					while ((bitcheck(LPUART1->ISR, 7) == 0));
					LPUART1->TDR = image[i];
				}
				break;
			case 'C': // Get categorized Image
				TakePic(image);
				image_color_classify(image, classified_image, &sticker_codes);
				for (uint16_t i = 0; i < 27648; i ++) {
					while ((bitcheck(LPUART1->ISR, 7) == 0));
					LPUART1->TDR = image[i];
				}
				for (uint16_t i = 0; i < 27648; i ++) {
					while ((bitcheck(LPUART1->ISR, 7) == 0));
					LPUART1->TDR = classified_image[i];
				}
				break;
			case 'c': // Get categorized Image
				TakePic(image);
				for (uint16_t i = 0; i < 27648; i ++) {
					while ((bitcheck(LPUART1->ISR, 7) == 0));
					LPUART1->TDR = image[i];
				}
				image_color_classify(image, classified_image, &sticker_codes);
				for (uint16_t i = 0; i < 27648; i ++) {
					while ((bitcheck(LPUART1->ISR, 7) == 0));
					LPUART1->TDR = classified_image[i];
				}
				break;
			case 'S': // Get cube state
				Cube_Eval(&image, &classified_image, &cube);
				break;
			case 's': // Get cube state
				Cube_Eval(&image, &classified_image, &cube);
				break;
			case 'L': // Clockwise
				MoveCode = 0;
				break;
			case 'l': // Counter Clockwise
				MoveCode = 1;
				break;
			case 'R': // Clockwise
				MoveCode = 2;
				break;
			case 'r': // Counter Clockwise
				MoveCode = 3;
				break;
			case 'U': // Clockwise
				MoveCode = 4;
				break;
			case 'u': // Counter Clockwise
				MoveCode = 5;
				break;
			case 'D': // Clockwise
				MoveCode = 6;
				break;
			case 'd': // Counter Clockwise
				MoveCode = 7;
				break;
			case 'F': // Clockwise
				MoveCode = 8;
				break;
			case 'f': // Counter Clockwise
				MoveCode = 9;
				break;
			case 'B': // Clockwise
				MoveCode = 10;
				break;
			case 'b': // Counter Clockwise
				MoveCode = 11;
				break;


	    	}

	    	if (MoveCode < 12){
				motorControl(MoveCode, DEFAULT_MOTOR_SPEED);
				delay_ms(100);
	    	}
			rxBuffer[buffer_pntr] = 0;

	    	buffer_pntr++;
			if (buffer_pntr == bufferIndex){
				buffer_pntr = 0;
				bufferIndex = 0;
			}
	    }
	    else if (moveComplete){
			bitset(GPIOD->ODR,14); // Disable Motors
	    }
	}
}

//Function Declarations ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
void configGPIOD(){
	/**
	 * Function to set GPIOD pins as outputs
	 */
	RCC->AHB2ENR  |= (1<<3); // Enable GPIOD
	GPIOD->MODER &= ~(0xFfffffff); // clearing 0-13
	GPIOD->MODER |=   0x51455555; // setting 0-9,11-12,14-15 as output

	bitset(GPIOD->ODR,14); // Disable Motors Initially

}

void InitGPIOE(){
	/**
	  * @brief	A function to enable/configure GPIOE.
	  * @param 	None
	  * @retval	None
	*/

	bitset(RCC->AHB2ENR,4);	// Enable Clock to GPIOE

	//Set GPIO Port E, Pin 12 to 'b01 "General purpose output mode".
	bitclear(GPIOE->MODER, 25);
	bitset(GPIOE->MODER, 24);

	//Set GPIO Port E, Pin 13 to "Alternate Function".
	bitset(GPIOE->MODER, 27);
	bitclear(GPIOE->MODER, 26);
	bitclear(GPIOE->AFR[1], 23);  // Programming 'b0101 (AF5 = SPI1_SCK)
	bitset(GPIOE->AFR[1], 22);
	bitclear(GPIOE->AFR[1], 21);
	bitset(GPIOE->AFR[1], 20);
	bitset(GPIOE->OSPEEDR, 27); // Set OSPEED to 'b11 (High-High Speed)
	bitset(GPIOE->OSPEEDR, 26);


	//Set GPIO Port E, Pin 14 to "Alternate Function".
	bitset(GPIOE->MODER, 29);
	bitclear(GPIOE->MODER, 28);
	bitclear(GPIOE->AFR[1], 27);  // Programming 'b0101 (AF5 = SPI1_MISO)
	bitset(GPIOE->AFR[1], 26);
	bitclear(GPIOE->AFR[1], 25);
	bitset(GPIOE->AFR[1], 24);
	bitset(GPIOE->OSPEEDR, 29); // Set OSPEED to 'b11 (High-High Speed)
	bitset(GPIOE->OSPEEDR, 28);

	//Set GPIO Port E, Pin 15 to "Alternate Function".
	bitset(GPIOE->MODER, 31);
	bitclear(GPIOE->MODER, 30);
	bitclear(GPIOE->AFR[1], 31);  // Programming 'b0101 (AF5 = SPI1_MOSI)
	bitset(GPIOE->AFR[1], 30);
	bitclear(GPIOE->AFR[1], 29);
	bitset(GPIOE->AFR[1], 28);
	bitset(GPIOE->OSPEEDR, 31); // Set OSPEED to 'b11 (High-High Speed)
	bitset(GPIOE->OSPEEDR, 30);

}

void InitGPIOG(){
	/**
	  * @brief	A function to enable/configure GPIOG.
	  * @param 	None
	  * @retval	None
	*/

	bitset(RCC->AHB2ENR,   6);  // Enable Clock to GPIOG
	bitset(RCC->APB1ENR1, 28);  // Enable Clock to PWR Interface
	bitset(PWR->CR2, 9);        // Enable GPIOG power

	//Set GPIOG.7 to AF8 (LPUART1_TX)
	bitset(GPIOG->MODER,    15);  // Setting 0b10 (Alternate Function) in pin 7 two bit mode cfgs
	bitclear(GPIOG->MODER,  14);

	bitset(GPIOG->AFR[0],   31);  // Programming 0b1000 (AF8 = LPUART1_TX)
	bitclear(GPIOG->AFR[0], 30);
	bitclear(GPIOG->AFR[0], 29);
	bitclear(GPIOG->AFR[0], 28);

	//Set GPIOG.8 to AF8 (LPUART1_RX)
	bitset(GPIOG->MODER,    17);  // Setting 0b10 (Alternate Function) in pin 8 two bit mode cfgs
	bitclear(GPIOG->MODER,  16);

	bitset(GPIOG->AFR[1], 3);  // Programming 0b1000 (AF8 = LPUART1_RX)
	bitclear(GPIOG->AFR[1], 2);
	bitclear(GPIOG->AFR[1], 1);
	bitclear(GPIOG->AFR[1], 0);

}

void setClks(){
	RCC->APB1ENR1 |=1<<28;   // Enable the power interface clock by setting the PWREN bits
	RCC->APB1ENR2 |= (1<<0);     // Enable LPUART1EN clock
	RCC->CCIPR1   |= (1<<11); // select HSI as the LPUART clock
	RCC->CCIPR1   &= ~(1<<10);
	RCC->CFGR     |=0x1;     // Use HSI16 as SYSCLK
	RCC->CR       |= (1<<8);   // HSI16 clock enable
	RCC->CR		  |= 0x161; // MSI on, reset state, HSI on
	RCC->AHB2ENR  |= (1<<4); // enabling GPIOE
	RCC->AHB2ENR  |= (1<<6); // enabling GPIOG
	RCC->APB2ENR  |= (1<<0); // enabling clock to SYSCFG and EXTI
	// LCD specific
	RCC->APB1ENR1 |= (1<<19); // enable UART4
	RCC->AHB2ENR |= (1<<2); // Enable GPIOC
}

void InitLPUART1(uint32_t baud, uint8_t stop, uint8_t data_len, bool parity_en, bool parity_odd){
	/**
	  * @brief   This function initializes LPUART1 with the given baud rate, stop bits, data length, and parity settings.
	  * @param    baud:       The baud rate for LPUART1 communication.
	  * @param    stop:       The number of stop bits to be used.
	  *                       This could be 1 or 2, defining the end of a frame of data.
	  * @param    data_len:   The length of data bits in UART communication.
	  *                       This could be 7, 8 or 9.
	  * @param    parity_en:  Enable or disable parity check.
	  *                       If true, parity checking is enabled, otherwise it's disabled.
	  * @param    parity_odd: Define the type of parity (if parity is enabled).
	  *                       If true, odd parity is used; if false, even parity is used.
	  * @retval   None
	*/
	uint32_t reg_val = 256*(16000000/baud);
	bitset(RCC->APB1ENR2,  0);  // Enable Clock to LPUART

	bitset(RCC->CCIPR1,   11);  // Select the high speed internal (HSI) oscillator as the clock to LPUART1 (16MHz)
	bitclear(RCC->CCIPR1, 10);  //
	bitset(RCC->CR, 8);         // HSI16 clock enable

	// Configure the # of stop bits.
	if (stop == 1){
		bitclear(LPUART1->CR2,13);
		bitclear(LPUART1->CR2,12);
	} else if (stop == 2) {
		bitset(LPUART1->CR2,13);
		bitclear(LPUART1->CR2,12);
	}

	// Configure the # of data bits.
	if (data_len == 7){
		bitset(LPUART1->CR1,28);
		bitclear(LPUART1->CR1,12);
	} else if (data_len == 8) {
		bitclear(LPUART1->CR1,28);
		bitclear(LPUART1->CR1,12);
	} else if (data_len == 9) {
		bitclear(LPUART1->CR1,28);
		bitset(LPUART1->CR1,12);
	}


	// Configure the parity.
	if (parity_en){
		bitset(LPUART1->CR1,10);

		//Configure parity odd/even if parity is enabled.
		if (parity_odd){
			bitset(LPUART1->CR1,9);
		} else{
			bitclear(LPUART1->CR1,9);
		}
	} else {
		bitclear(LPUART1->CR1,10);
	}

	LPUART1->BRR = reg_val;
	bitset(LPUART1->CR1,5);// Enable Receive Data Not Empty Interrupt (RXNEIE)
	bitset(LPUART1->CR1,3);// Enable Transmitter
	bitset(LPUART1->CR1,2);// Enable Receiver
	bitset(LPUART1->CR1,0);// Enable LPUART1


	NVIC_SetPriority(LPUART1_IRQn, 1);// Set Interrupt Priority

	NVIC_EnableIRQ(LPUART1_IRQn);// Enable IRQ in NVIC

}

void InitSPI(){
	/**
	 * @brief  Initializes the SPI interface with predefined settings.
	 * @param  None
	 * @retval None
	 */

	bitset(RCC->APB2ENR,12);// Enable clock to SPI1.

	bitclear(SPI1->CR1,5); // Set Baud Rate Control = 'b000 (fPCLK/2). This should be 16MHz/2 = 8MHz (Suggested in arducam documentation.).
	bitclear(SPI1->CR1,4);
	bitclear(SPI1->CR1,3);

	bitset(SPI1->CR1,2); // Set to master.

	bitclear(SPI1->CR1,1); // Set clock polarity to 0.
	bitclear(SPI1->CR1,0); // Set clock phase to 0.

	bitset(SPI1->CR2,11); // Set data size to 'b1111 (16-bit)
	bitset(SPI1->CR2,10);
	bitset(SPI1->CR2,9);
	bitset(SPI1->CR2,8);

	bitset(SPI1->CR1,9); // Enable software slave management.
	bitset(SPI1->CR1, 8); // SSI: Internal slave select set.

    bitset(GPIOE->ODR, 12); // De-select the slave device
	bitset(SPI1->CR1,6); // Enable SPI1.
}

void WriteSPI(uint8_t addr, uint8_t* data, uint16_t length){
    /**
      * @brief  		Function to write register address and data over SPI to a camera.
      * @param  addr 	The register address where data should be written.
      * @param  data    Pointer to the data array for write operations.
      * @param  length  The length of the data to send.
      * @retval None
      */


    addr |= 0x80;  									// Set the MSB to ensure it's a write operation (0x80 = 1000 0000 in binary)

    uint8_t clean_cnt = 0;
    while (bitcheck(SPI1->SR,1) != 1);				// Wait for the transmit buffer to be empty.

    bitclear(GPIOE->ODR, 12); 						// Select the slave device by pulling its CS (Chip Select) low.

	SPI1->DR = ConcatenateWords(addr, data[0]); 	// Send instruction and address if both are enabled.
	clean_cnt++; 									// Set number of cleanup reads needed for RXNE flag.

	if (length > 1){
		for (uint16_t i = 1; i < length; i += 2) {
			uint16_t two_bytes = 0x00; 				// Initialize with zeroes to build the data word.
			if (i + 1 < length) {
				two_bytes = ConcatenateWords(data[i], data[i + 1]); // Concatenate two bytes if possible.
			} else {
				two_bytes = data[i] << 8; 							// Only one byte left, shift it to the MSB.
			}

			SPI1->DR = two_bytes; 					// Send the data word.
			while (bitcheck(SPI1->SR, 1) != 1); 	// Wait for the transmit buffer to be empty again.
		}
		clean_cnt++; 								// Set number of cleanup reads needed for RXNE flag.
	}

    while (bitcheck(SPI1->SR,1) != 1);	// Wait again for the transmit buffer to be empty.
    while (bitcheck(SPI1->SR,7) != 0); 	// Wait until SPI is not busy (BSY flag is cleared).
    bitset(GPIOE->ODR, 12); 			// De-select the slave device by pulling CS high.

    while (clean_cnt > 0){
        (void)SPI1->DR; 				// Perform cleanup reads to clear RXNE flag.
        clean_cnt -= 1;
    }

}

uint8_t ReadSPIByte(uint8_t addr){
    /**
      * @brief      Function to read data from a camera register over SPI.
      * @param  addr     The register address from which data should be read.
      * @param  data     Pointer to the data array to store the read data.
      * @param  length   The number of bytes of data to read.
      * @retval None
      */

	uint8_t return_val = 0;
	addr &= 0x7F;  							  // Clear the MSB to ensure it's a read operation (0x7F = 0111 1111 in binary)

    while (bitcheck(SPI1->SR, 1) != 1);       // Wait for the transmit buffer to be empty.

    bitclear(GPIOE->ODR, 12);                 // Select the slave device by pulling its CS (Chip Select) low.

    SPI1->DR =  ConcatenateWords(addr,0x00); // Send the register address.
    while (bitcheck(SPI1->SR, 0) != 1);   // Wait until the receive buffer is not empty (RXNE).
    (void)SPI1->DR;


	// Send dummy words and read the data
	SPI1->DR = 0x0000;                    // Send a dummy word to generate clock for reading data.
	while (bitcheck(SPI1->SR, 1) != 1);   // Wait for the transmit buffer to be empty.
	while (bitcheck(SPI1->SR, 0) != 1);   // Wait until the receive buffer is not empty (RXNE).
	uint16_t receivedWord = SPI1->DR;     // Read the received word.

	return_val = (uint8_t)(receivedWord >> 8);  // Extract the Upper 8 bits as the received data.

    while (bitcheck(SPI1->SR, 7) != 0);       // Wait until SPI is not busy (BSY flag is cleared).
    bitset(GPIOE->ODR, 12);                   // De-select the slave device by pulling CS high.

    return return_val;
}

void ReadSPI(uint8_t addr, uint8_t* data, uint16_t length, bool immediate){
    /**
      * @brief      Function to read data from a camera register over SPI.
      * @param  addr     The register address from which data should be read.
      * @param  data     Pointer to the data array to store the read data.
      * @param  length   The number of bytes of data to read.
      * @retval None
      */

	addr &= 0x7F;  							  // Clear the MSB to ensure it's a read operation (0x7F = 0111 1111 in binary)

    while (bitcheck(SPI1->SR, 1) != 1);       // Wait for the transmit buffer to be empty.

    bitclear(GPIOE->ODR, 12);                 // Select the slave device by pulling its CS (Chip Select) low.

    SPI1->DR =  ConcatenateWords(addr, 0x00); // Send the register address.
    while (bitcheck(SPI1->SR, 0) != 1);   // Wait until the receive buffer is not empty (RXNE).

    if (immediate){
    	data[0] = (SPI1->DR & 0xFF); 				// Perform cleanup reads to clear RXNE flag.


        // Send dummy words and read the data
        for (uint16_t i = 1; i < length; i += 2) {
            SPI1->DR = 0x0000;                    // Send a dummy word to generate clock for reading data.
            while (bitcheck(SPI1->SR, 1) != 1);   // Wait for the transmit buffer to be empty.
            while (bitcheck(SPI1->SR, 0) != 1);   // Wait until the receive buffer is not empty (RXNE).
            uint16_t receivedWord = SPI1->DR;     // Read the received word.

            data[i] = (uint8_t)(receivedWord >> 8);  // Extract the Upper 8 bits as the received data.
            if (i < (length-1)){
                data[i+1] = (uint8_t)(receivedWord & 0xFF);  // Extract the Lower 8 bits as the received data.
            }
        }

    } else{
    	(void)SPI1->DR; 				// Perform cleanup reads to clear RXNE flag.


        // Send dummy words and read the data
        for (uint16_t i = 0; i < length; i += 2) {
            SPI1->DR = 0x0000;                    // Send a dummy word to generate clock for reading data.
            while (bitcheck(SPI1->SR, 1) != 1);   // Wait for the transmit buffer to be empty.
            while (bitcheck(SPI1->SR, 0) != 1);   // Wait until the receive buffer is not empty (RXNE).
            uint16_t receivedWord = SPI1->DR;     // Read the received word.

            data[i] = (uint8_t)(receivedWord >> 8);  // Extract the Upper 8 bits as the received data.
            if (i < (length-1)){
                data[i+1] = (uint8_t)(receivedWord & 0xFF);  // Extract the Lower 8 bits as the received data.
            }
        }
    }

    while (bitcheck(SPI1->SR, 7) != 0);       // Wait until SPI is not busy (BSY flag is cleared).
    bitset(GPIOE->ODR, 12);                   // De-select the slave device by pulling CS high.
}

void InitCamera(){
	uint8_t reg_data[1];
	uint8_t status_data[1];

    delay_ms(1000); // Delay for camera to boot.

    reg_data[0] = (1<<6);
	WriteSPI(CAM_REG_SENSOR_RESET, reg_data, 1);

	status_data[0] = 0;
	while ((status_data[0] & 0x02) == 0){
		ReadSPI(CAM_REG_SENSOR_STATE, status_data,1, 0);
	}

    delay_ms(1000);
    reg_data[0] = 0; // One Frame
	WriteSPI(CAM_REG_FRAME_NUM, reg_data, 1);

    delay_ms(1000);
    reg_data[0] = 2; // RGB format
	WriteSPI(CAM_REG_FORMAT, reg_data, 1);

    delay_ms(1000);
    reg_data[0] = 10; // 96x96 resolution
	WriteSPI(CAM_REG_CAPTURE_RESOLUTION, reg_data, 1);

    delay_ms(1000);
    reg_data[0] = 1; // Clear write complete flag
	WriteSPI(CAM_REG_MEM_CNTRL, reg_data, 1);
}

void TakePic(uint8_t* image){
    uint8_t image565[18432];    // Pixel array for RGB565 format (96x96x2 bytes)
    Color converted_px;         // Temporary Color struct to hold converted pixels
    uint8_t reg_data[1];        // Register data for camera commands
    uint8_t status_data[1];     // Status data from camera
    uint16_t px_loc;            // Index location in RGB888 array

    bitset(GPIOD->ODR,15);      // Turn On LED Strips
    delay_ms(500);              // Delay for lighting to stabilize

    reg_data[0] = 2;            // Command to take a picture
    WriteSPI(CAM_REG_MEM_CNTRL, reg_data, 1);  // Send the capture command

    delay_ms(500);              // Delay to allow capture time
    status_data[0] = 0;
    while ((status_data[0] & 0x02) == 0){       // Wait for image capture completion
        ReadSPI(CAM_REG_SENSOR_STATE, status_data, 1, false);
    }


    bitclear(GPIOD->ODR,15);    // Turn Off LED Strips

    // Read image data from camera's FIFO in RGB565 format
    for (uint16_t i = 0; i < 18432; i ++) {
        image565[i] = ReadSPIByte(CAM_REG_SINGLE_FIFO_READ_OPERATION);
    }

    // Convert RGB565 to RGB888 format
    for (uint16_t i = 0; i < 18432; i +=2) {
        converted_px = convertRGB565toRGB888(ConcatenateWords(image565[i],image565[i+1]));
        px_loc = ((i*3)/2);
        image[px_loc] = converted_px.r;
        image[px_loc+1] = converted_px.g;
        image[px_loc+2] = converted_px.b;
    }
}

void normalize(float rgb[3]) {
    float norm = sqrt(rgb[0] * rgb[0] + rgb[1] * rgb[1] + rgb[2] * rgb[2]); // Calculate the L2 norm (Euclidean)
    if (norm > 0) {  // Avoid division by zero
        rgb[0] /= norm; // Normalize red component
        rgb[1] /= norm; // Normalize green component
        rgb[2] /= norm; // Normalize blue component
    }
}

HSV rgb_to_hsv(int r, int g, int b) {
    float r_prime = r / 255.0f;  // Normalize R to 0-1
    float g_prime = g / 255.0f;  // Normalize G to 0-1
    float b_prime = b / 255.0f;  // Normalize B to 0-1
    float c_max = fmax(fmax(r_prime, g_prime), b_prime); // Find the maximum of r, g, b
    float c_min = fmin(fmin(r_prime, g_prime), b_prime); // Find the minimum of r, g, b
    float delta = c_max - c_min; // Difference between max and min

    HSV hsv;
    // Calculate Hue
    if (delta == 0) {
        hsv.h = 0;  // No color difference
    } else {
        if (c_max == r_prime) {
            hsv.h = fmod(((g_prime - b_prime) / delta) * 60.0 + 360.0, 360.0);
        } else if (c_max == g_prime) {
            hsv.h = fmod(((b_prime - r_prime) / delta + 2) * 60.0, 360.0);
        } else if (c_max == b_prime) {
            hsv.h = fmod(((r_prime - g_prime) / delta + 4) * 60.0, 360.0);
        }
    }

    // Calculate Saturation
    hsv.s = (c_max == 0) ? 0 : delta / c_max;

    // Calculate Value
    hsv.v = c_max;

    return hsv;
}

Color find_closest_hsv_color(uint8_t r, uint8_t g, uint8_t b) {
    // Convert RGB to HSV
    HSV hsv_pixel = rgb_to_hsv(r, g, b);

    if ((hsv_pixel.s < 0.255)) {
        // If saturation is low, consider the color as white
        return pure_colors[5];  // Index of white in pure_colors
    }

    // Define your colors in HSV space
    HSV hsv_colors[] = {
        {359, 1, 1},       // Red
        {120, 1, 1},     // Green
        {240, 1, 1},     // Blue
        {60, 1, 1},      // Yellow
        {20, 1, 1},      // Orange
        {0, 0, 1}        // White
    };


    // Match with predefined colors
    int closest_color_index = 0;
    float min_distance = FLT_MAX;

    for (int i = 0; i < 6; i++) {
        // Compute the distance between the two colors in HSV space
        float dh = fmin(fabs(hsv_pixel.h - hsv_colors[i].h), 360 - fabs(hsv_pixel.h - hsv_colors[i].h)) / 180.0;
        float ds = fabs(hsv_pixel.s - hsv_colors[i].s);
        float dv = fabs(hsv_pixel.v - hsv_colors[i].v);
        float distance = sqrt(dh * dh + ds * ds + dv * dv);

        if (distance < min_distance) {
            min_distance = distance;
            closest_color_index = i;
        }
    }

    // Return the RGB color that corresponds to the closest HSV match
    return pure_colors[closest_color_index];
}


int find_color_index(uint8_t r, uint8_t g, uint8_t b) {
    // Iterate through predefined pure colors to find an exact match
    for (int i = 0; i < 6; i++) {
        if (pure_colors[i].r == r && pure_colors[i].g == g && pure_colors[i].b == b) {
            return i; // Return index of matching color
        }
    }
    return -1; // Return -1 if no match is found
}

uint8_t get_majority_color(uint8_t* classified_image, int x, int y) {
    int counts[6] = {0}; // Array to count occurrences of each color
    int width = 96; // Assume width of the image
    int height = 96; // Assume height of the image

    // Scan a 5x5 area centered at (x, y)
    for (int dx = -2; dx <= 2; dx++) {
        for (int dy = -2; dy <= 2; dy++) {
            int nx = x + dx;
            int ny = y + dy;
            if (nx >= 0 && nx < width && ny >= 0 && ny < height) {
                int index = (ny * width + nx) * 3; // Calculate index in the flat image array
                uint8_t r = classified_image[index];
                uint8_t g = classified_image[index + 1];
                uint8_t b = classified_image[index + 2];
                int color_index = find_color_index(r, g, b); // Find color index for the pixel
                if (color_index != -1) {
                    counts[color_index]++; // Increment count for this color
                }
            }
        }
    }

    // Find the color with the maximum count
    uint8_t majority_color = 0;
    int max_count = 0;
    for (int i = 0; i < 6; i++) {
        if (counts[i] > max_count) {
            max_count = counts[i];
            majority_color = color_codes[i]; // Match index to color code
        }
    }
    return majority_color; // Return the most frequent color code
}

void image_color_classify(uint8_t* image, uint8_t* classified_image, Eval_Codes* codes){
    Color classified_px;  // Temporary storage for the converted color

    // Positions on the image where specific colors will be evaluated
    uint8_t target_posx[] = {27, 37, 52, 64, 75, 22, 32, 44, 44, 56, 69, 80, 56};
    uint8_t target_posy[] = {14, 25, 35, 24, 16, 28, 39, 52, 62, 52, 38, 28, 62};
    int num_targets = sizeof(target_posx) / sizeof(target_posx[0]);  // Number of target positions

    // Classify each pixel in the image and store the results in classified_image
    for (uint16_t i = 0; i < 27648; i += 3) {
        classified_px = find_closest_hsv_color(image[i], image[i+1], image[i+2]);
        classified_image[i] = classified_px.r;
        classified_image[i+1] = classified_px.g;
        classified_image[i+2] = classified_px.b;
    }

    // Evaluate specific positions on the classified image to determine the majority colors
    for (uint8_t i = 0; i < num_targets; i++){
        int x = target_posx[i];  // X-coordinate of the target position
        int y = target_posy[i];  // Y-coordinate of the target position
        uint8_t color_code = get_majority_color(classified_image, x, y);

        // Store the majority color code in the appropriate field of the Eval_Codes struct
        switch (i) {
            case 0: codes->v1 = color_code; break;
            case 1: codes->v2 = color_code; break;
            case 2: codes->v3 = color_code; break;
            case 3: codes->v4 = color_code; break;
            case 4: codes->v5 = color_code; break;
            case 5: codes->r1 = color_code; break;
            case 6: codes->r2 = color_code; break;
            case 7: codes->r3 = color_code; break;
            case 8: codes->r4 = color_code; break;
            case 9: codes->l1 = color_code; break;
            case 10: codes->l2 = color_code; break;
            case 11: codes->l3 = color_code; break;
            case 12: codes->l4 = color_code; break;
            default: break;
        }
    }
}


Color convertRGB565toRGB888(uint16_t rgb565){
	Color rgb888;

    // Extract the red, green, and blue components from the RGB565 value
    uint8_t r5 = (rgb565 >> 11) & 0x1F;
    uint8_t g6 = (rgb565 >> 5) & 0x3F;
    uint8_t b5 = rgb565 & 0x1F;

    // Convert and scale to the RGB888 format
    rgb888.r = ((r5 *255)/ 31);
    rgb888.g = ((g6 *255)/ 63);
    rgb888.b = ((b5 *255)/ 31);

    return rgb888;
}

void sendCube(RubiksCube *cube) {
    const uint8_t *bytePtr = (const uint8_t*)cube; // Cast cube state to a byte pointer for serialization
    size_t numBytes = sizeof(RubiksCube); // Compute the number of bytes in the RubiksCube struct

    for (size_t i = 0; i < numBytes; i++) {
        while ((bitcheck(LPUART1->ISR, 7) == 0)); // Wait until the UART data register is empty
        LPUART1->TDR = bytePtr[i]; // Transmit the current byte of the cube state
    }
}

void Cube_Eval(uint8_t* image, uint8_t* classified_image, RubiksCube* cube){
	Eval_Codes sticker_codes = {0};

	TakePic(image);

	image_color_classify(image, classified_image, &sticker_codes);

	cube->down[2][2] = sticker_codes.v1;
	cube->down[1][2] = sticker_codes.v2;
	cube->down[0][2] = sticker_codes.v3;
	cube->down[0][1] = sticker_codes.v4;
	cube->down[0][0] = sticker_codes.v5;
	cube->right[2][2] = sticker_codes.r1;
	cube->right[2][1] = sticker_codes.r2;
	cube->right[2][0] = sticker_codes.r3;
	cube->right[1][0] = sticker_codes.r4;
	cube->front[2][2] = sticker_codes.l1;
	cube->front[2][1] = sticker_codes.l2;
	cube->front[2][0] = sticker_codes.l3;
	cube->front[1][2] = sticker_codes.l4;


    motorControl(6, INSPECTION_MOTOR_SPEED); // Down - Clockwise
	while (moveComplete == false); // Wait for move complete
    delay_ms(100);
    motorControl(6, INSPECTION_MOTOR_SPEED); // Down - Clockwise
	while (moveComplete == false); // Wait for move complete
	bitset(GPIOD->ODR,14); // Disable Motors

	TakePic(image);

	image_color_classify(image, classified_image, &sticker_codes);

	cube->down[1][0] = sticker_codes.v2;
	cube->down[2][0] = sticker_codes.v3;
	cube->down[2][1] = sticker_codes.v4;
	cube->left[2][2] = sticker_codes.r1;
	cube->left[2][1] = sticker_codes.r2;
	cube->left[2][0] = sticker_codes.r3;
	cube->back[2][2] = sticker_codes.l1;
	cube->back[2][1] = sticker_codes.l2;
	cube->back[2][0] = sticker_codes.l3;

    motorControl(8, INSPECTION_MOTOR_SPEED); // Front - Clockwise
	while (moveComplete == false); // Wait for move complete
    delay_ms(100);
    motorControl(8, INSPECTION_MOTOR_SPEED); // Front - Clockwise
	while (moveComplete == false); // Wait for move complete
	bitset(GPIOD->ODR,14); // Disable Motors

	TakePic(image);

	image_color_classify(image, classified_image, &sticker_codes);

	cube->up[2][0] = sticker_codes.v3;
	cube->up[2][1] = sticker_codes.v4;
	cube->up[2][2] = sticker_codes.v5;
	cube->left[0][2] = sticker_codes.r3;
	cube->left[1][2] = sticker_codes.r4;
	cube->front[0][0] = sticker_codes.l1;
	cube->front[0][1] = sticker_codes.l2;
	cube->front[0][2] = sticker_codes.l3;
	cube->front[1][0] = sticker_codes.l4;

    motorControl(9, INSPECTION_MOTOR_SPEED); // Front - Counter Clockwise
	while (moveComplete == false); // Wait for move complete
    delay_ms(100);
    motorControl(9, INSPECTION_MOTOR_SPEED); // Front - Counter Clockwise
	while (moveComplete == false); // Wait for move complete
    delay_ms(100);
    motorControl(2, INSPECTION_MOTOR_SPEED); // Right - Clockwise
	while (moveComplete == false); // Wait for move complete
    delay_ms(100);
    motorControl(2, INSPECTION_MOTOR_SPEED); // Right - Clockwise
	while (moveComplete == false); // Wait for move complete
	bitset(GPIOD->ODR,14); // Disable Motors

	TakePic(image);

	image_color_classify(image, classified_image, &sticker_codes);

	cube->up[1][2] = sticker_codes.v2;
	cube->up[0][2] = sticker_codes.v3;
	cube->right[0][0] = sticker_codes.r1;
	cube->right[0][1] = sticker_codes.r2;
	cube->right[0][2] = sticker_codes.r3;
	cube->right[1][2] = sticker_codes.r4;
	cube->back[0][0] = sticker_codes.l1;
	cube->back[1][0] = sticker_codes.l4;

    motorControl(4, INSPECTION_MOTOR_SPEED); // Up - Clockwise
	while (moveComplete == false); // Wait for move complete
    delay_ms(100);
    motorControl(4, INSPECTION_MOTOR_SPEED); // Up - Clockwise
	while (moveComplete == false); // Wait for move complete
    delay_ms(100);
    motorControl(2, INSPECTION_MOTOR_SPEED); // Right - Clockwise
	while (moveComplete == false); // Wait for move complete
    delay_ms(100);
    motorControl(2, INSPECTION_MOTOR_SPEED); // Right - Clockwise
	while (moveComplete == false); // Wait for move complete
	bitset(GPIOD->ODR,14); // Disable Motors

	TakePic(image);

	image_color_classify(image, classified_image, &sticker_codes);

	cube->up[0][0] = sticker_codes.v1;
	cube->up[1][0] = sticker_codes.v2;
	cube->left[0][0] = sticker_codes.r1;
	cube->left[0][1] = sticker_codes.r2;

    motorControl(2, INSPECTION_MOTOR_SPEED); // Right - Clockwise
	while (moveComplete == false); // Wait for move complete
	bitset(GPIOD->ODR,14); // Disable Motors

	TakePic(image);

	image_color_classify(image, classified_image, &sticker_codes);

	cube->back[0][2] = sticker_codes.v3;

    motorControl(10, INSPECTION_MOTOR_SPEED); // Back - Clockwise
	while (moveComplete == false); // Wait for move complete
    delay_ms(100);
    motorControl(10, INSPECTION_MOTOR_SPEED); // Back - Clockwise
	while (moveComplete == false); // Wait for move complete
    delay_ms(100);
    motorControl(2, INSPECTION_MOTOR_SPEED); // Right - Clockwise
	while (moveComplete == false); // Wait for move complete
    delay_ms(100);
    motorControl(8, INSPECTION_MOTOR_SPEED); // Front - Clockwise
	while (moveComplete == false); // Wait for move complete
    delay_ms(100);
    motorControl(8, INSPECTION_MOTOR_SPEED); // Front - Clockwise
	while (moveComplete == false); // Wait for move complete
	bitset(GPIOD->ODR,14); // Disable Motors

	TakePic(image);

	image_color_classify(image, classified_image, &sticker_codes);

	cube->back[1][2] = sticker_codes.v2;
	cube->up[0][1] = sticker_codes.v4;
	cube->left[1][0] = sticker_codes.r2;
	cube->back[0][1] = sticker_codes.l2;

	sendCube(cube);

}

/**
 * LCD Stuff
 */
// defining LCD-related functions  //
menuitem* newMenuItem(menuitem* parentMenu, char *strName, int numMenuItems, int arrayPos){
	/**
	 *	Creates top or sub menu.
	 *
	 *	parentMenu:   menuitem parent, or top menu for created menu
	 *	strName:	  name of menu (or submenu)
	 *	numMenuItems: number of submenus for created menu
	 *	arrayPos:	  used to indicate index of parent's submenu array
	 */
	menuitem* newMenuItem = (menuitem*)malloc(sizeof(menuitem)); // assigning size to memory
	memset(newMenuItem, 0, sizeof(menuitem)); // make sure memory is set to 0
	newMenuItem->menuitems = (menuitem**)calloc(sizeof(menuitem*), numMenuItems); // assigning submenu size
	newMenuItem->name = strName;
	if (parentMenu) {
		parentMenu->menuitems[arrayPos] = newMenuItem; // assigning newMenu to parent menuitems (submenus)
		newMenuItem->parent = parentMenu; // assigning newMenu's parent
	}

	return newMenuItem;
}

void motorxHandler(menuitem* motor){
	/**
	 * Function for motor options submenu
	 * Calls writeScreen("motorName", "L -90 / R +90"), and
	 * calls motorControl(motorx code) to turn motor when called
	 */
	// prints motor name, and, if provided, turns motor
	cursorControl(NULL);
	writeScreen(motor->name, "L -90 / R +90");
	cursorControl(motor->name);
}

void initMenus(){
	/**
	 * Function to create menus and submenus
	 */
	// MAIN MENU
	mainMenu = newMenuItem(NULL, "Main Menu", NUM_MAIN_MENU_OPTIONS, 0);
	mainMenu->handler = writeScreen;
	// Instruction/Help Menu
	helpMenu = newMenuItem(mainMenu, "Help Menu", 0, 0);
	helpMenu->handler = writeScreen;

	// Motor Menu
	motorOptions = newMenuItem(mainMenu, "Motor Options", NUM_MOTOR_OPTIONS, 1);
	motorOptions->handler = writeScreen;
		// Motor submenus
		motorRight = newMenuItem(motorOptions, "Right Motor", 0, 0);
		motorRight->handler = motorxHandler;

		motorLeft = newMenuItem(motorOptions, "Left Motor", 0, 1);
		motorLeft->handler = motorxHandler;

		motorUp = newMenuItem(motorOptions, "Up Motor", 0, 2);
		motorUp->handler = motorxHandler;

		motorDown = newMenuItem(motorOptions, "Down Motor", 0, 3);
		motorDown->handler = motorxHandler;

		motorFront = newMenuItem(motorOptions, "Front Motor", 0, 4);
		motorFront->handler = motorxHandler;

		motorBack = newMenuItem(motorOptions, "Back Motor", 0, 5);
		motorBack->handler = motorxHandler;
	// Auto Menu
	autoMenu = newMenuItem(mainMenu, "Auto Menu", NUM_AUTO_OPTIONS, 2);
	autoMenu->handler = writeScreen;
		// auto submenus
		autoMenu2 = newMenuItem(autoMenu, "Auto Menu_2", 0, 0);
		autoMenu2->handler = writeScreen;
}

void HelpMenu(){
	/**
	 * Function to print Help Menu (and submenus) to LCD screen
	 */
	// configuring cursor
	cursorControl(NULL);
	sendDataUART4(LCD_START_COMMAND);
	sendDataUART4(LCD_CUR_OFF);

	helpMenu->handler("To navigate use", "the buttons");
	delay_ms(2000);
	helpMenu->handler("Up   Button UB", "Down Button DB");
	delay_ms(2000);
	helpMenu->handler("Left  Button LB", "Right Button RB");
	delay_ms(2000);
	helpMenu->handler("Middle Button MB", "Next: button def");
	delay_ms(2000);
	helpMenu->handler("Up Button UB: ^", "up menus      | ");
	delay_ms(2000);
	helpMenu->handler("Down Button DB:|", "down menus     v");
	delay_ms(2000);
	helpMenu->handler("Left Button LB:", "left control");
	delay_ms(2000);
	helpMenu->handler("Right Button RB:", "right control");
	delay_ms(2000);
	helpMenu->handler("Middle Button MB:", "select option");
	delay_ms(2000);
}

void MenuOptions(menuitem* Menu, int sel, int next){
	/**
	 * Function to send to LCD selected menu's submenu
	 *
	 * Menu:	menu to use for submenu selection
	 * sel:		select menu
	 * next:	used if you want to display next item as well, else empty
	 */
    // Calculate the length of the menuitems array
    int arr_len = 0;
    if (Menu->menuitems[arr_len] != NULL) {
        // Calculate the length only if the menuitems array is not NULL
        while (Menu->menuitems[arr_len] != NULL) {
            arr_len++;
        }
    }
	char str1[17];
	char str2[17];
	memset(str1, 0, sizeof(str1));
	memset(str2, 0, sizeof(str2));
	strncpy(str1, Menu->menuitems[sel]->name, LCD_STR_LEN);
	if(next && next < arr_len){ // -1 to avoid out of bounds referencing
		strncpy(str2, Menu->menuitems[next]->name, LCD_STR_LEN);
	}
	else{
		strncpy(str2, " ", LCD_STR_LEN);
	}
	cursorControl(NULL); // reset cursor
	writeScreen(str1, str2);
	cursorControl(str1); // set cursor
}

void cursorControl(char *strIn){
	/**
	 * Function to move cursor to the end of top LCD line
	 *
	 * strIn:	string (as reference for amount of spaces to move)
	 * rst:		used to reset cursor (breaks out after reset)
	 */
	// send cursor home (can be used with strIn = NULL to reset cursor)
	sendDataUART4(LCD_START_COMMAND);
	sendDataUART4(LCD_CUR_HOME);
	if(strIn != NULL){
		// buffer
		char str[LCD_STR_LEN];
		strncpy(str, strIn, LCD_STR_LEN);
		// defining string length
		int len = strlen(strIn);
		int pos = 0;
		if(len < LCD_STR_LEN){
			while(pos < len){
				sendDataUART4(LCD_START_COMMAND);
				sendDataUART4(LCD_CUR_FORW);
				pos++;
			}
		}
		else{
			// condition for length of string == 16, so far, no need to
			// implement this
		}
	}
}

void initInputButtons(){
	/**
	 * Function used to initialize Input Pins for Buttons
	 * GPIOF1  -> right button
	 * GPIOE6  -> left button
	 * GPIOF9  -> middle button
	 * GPIOE10 -> down button
	 * GPIOF15 -> up button
	 * GPIOC (13) Return button
	 */
	// enabling clocks
	RCC->AHB2ENR |= (1<<0); // GPIOA clock
	RCC->AHB2ENR |= (1<<2); // GPIOC clock
	RCC->AHB2ENR |= (1<<3); // GPIOD clock
	RCC->AHB2ENR |= (1<<4); // GPIOE clock
	RCC->AHB2ENR |= (1<<5); // GPIOF clock
	RCC->AHB2ENR |= (1<<6); // GPIOG clock
	// configuring GPIOC (13) as input
	GPIOC->MODER &= ~(3<<26);
	// configuring GPIOF (1) as input
	GPIOF->MODER &= ~(3<<2);
	// configuring GPIOE (6 & 10) as input
	GPIOE->MODER &= ~(3<<12);
	GPIOE->MODER &= ~(3<<20);
	// configuring GPIOF (9, 15) as input
	GPIOF->MODER &= ~(3<<18);
	GPIOF->MODER &= ~(3<<30);

	// speed config
	GPIOC->OSPEEDR |= (3<<26); // PC13
	GPIOF->OSPEEDR |= (3<<2); // PF1
	GPIOE->OSPEEDR |= (3<<12); // PE6
	GPIOF->OSPEEDR |= (3<<18); // PF9
	GPIOE->OSPEEDR |= (3<<20); // PE10
	GPIOF->OSPEEDR |= (3<<30); // PF15
	// pull-down
	// configuring GPIOC (13) as pull-down
	GPIOC->PUPDR |= (2<<26);
	// configuring GPIOF (1) as pull-down
	GPIOF->PUPDR |= (2<<2);
	// configuring GPIOE (6 & 10) as pull-down
	GPIOE->PUPDR |= (2<<12);
	GPIOE->PUPDR |= (2<<20);
	// configuring GPIOF (9, 15) as pull-down
	GPIOF->PUPDR |= (2<<18);
	GPIOF->PUPDR |= (2<<30);

	// Setting interrupts
	EXTI->EXTICR[3] |= (0x02)<<8;  // Select PC13
	// Selecting trigger type
	EXTI->RTSR1 |= (1<<13);
	EXTI->IMR1  |= 1<<13; // Interrupt mask disable for PC13

	EXTI->EXTICR[0] |= (0x05)<<8;  // Select PF1
	// Selecting trigger type
	EXTI->RTSR1 |= (1<<1);
	EXTI->IMR1  |= (1<<1); // Interrupt mask disable for PF1

	EXTI->EXTICR[1] |= (0x4)<<16;  // Select PE6
	// Selecting trigger type
	EXTI->RTSR1 |= (1<<6);
	EXTI->IMR1  |= (1<<6); // Interrupt mask disable for PE6

	EXTI->EXTICR[2] |= (0x5)<<8;  // Select PF9
	// Selecting trigger type
	EXTI->RTSR1 |= (1<<9);
	EXTI->IMR1  |= (1<<9); // Interrupt mask disable for PF9

	EXTI->EXTICR[2] |= (0x4)<<16;  // Select PE10
	// Selecting trigger type
	EXTI->RTSR1 |= (1<<10);
	EXTI->IMR1  |= (1<<10); // Interrupt mask disable for PE10

	EXTI->EXTICR[3] |= (0x5)<<24;  // Select PF15
	// Selecting trigger type
	EXTI->RTSR1 |= (1<<15);
	EXTI->IMR1  |= (1<<15); // Interrupt mask disable for PF15

	NVIC_SetPriority(EXTI13_IRQn, 2); // decide on priority
	NVIC_SetPriority(EXTI1_IRQn, 2); // decide on interrupt priority
	NVIC_SetPriority(EXTI6_IRQn, 2); // decide on interrupt priority
	NVIC_SetPriority(EXTI10_IRQn, 2); // decide on interrupt priority
	NVIC_SetPriority(EXTI9_IRQn, 2); // decide on interrupt priority
	NVIC_SetPriority(EXTI15_IRQn, 2); // decide on interrupt priority

	NVIC_EnableIRQ(EXTI13_IRQn);
	NVIC_EnableIRQ(EXTI1_IRQn);
	NVIC_EnableIRQ(EXTI6_IRQn);
	NVIC_EnableIRQ(EXTI10_IRQn);
	NVIC_EnableIRQ(EXTI9_IRQn);
	NVIC_EnableIRQ(EXTI15_IRQn);
}

void initScreen(){
	/**
	 * Function to initialize screen's default settings
	 */
	// clear screen
	sendDataUART4(LCD_START_COMMAND);
	sendDataUART4(LCD_CLEAR);
	// startup screen
	sendDataUART4(LCD_START_COMMAND);
	sendDataUART4(LCD_STRT_SCR);
	writeScreen("Welcome to Rubik", "Cube Solver Menu");
	// cursor
	sendDataUART4(LCD_START_COMMAND);
	sendDataUART4(LCD_CUR_OFF);
	// reset cursor
	sendDataUART4(LCD_START_COMMAND);
	sendDataUART4(LCD_CUR_HOME);
}

void writeScreen(char *str1, char *str2){
	/**
	 * Function to write to both lines in LCD screen
	 * If only one is given, pad the other with spaces
	 * If both are > 0, write to lines (note max length is 16 bytes)
	 */
	// clear buffers
	clearbufs();
	// copy strings into buf1 and buf2 (up to 16 bytes)
	strncpy(buf1, str1, LCD_STR_LEN);
	strncpy(buf2, str2, LCD_STR_LEN);
	 // Pad with spaces if necessary
	 int len1 = (int)strlen(str1);
	 if (len1 < LCD_STR_LEN) {
		 memset(buf1 + len1, ' ', LCD_STR_LEN - len1);
	 }
	 int len2 = (int)strlen(str2);
	 if (len2 < LCD_STR_LEN) {
		 memset(buf2 + len2, ' ', LCD_STR_LEN - len2);
	 }
	// write to LCD screen
	transmitBufData(buf1);
	transmitBufData(buf2);
}

void clearbufs(){
	/**
	 * Used to clear global buffers
	 */
	memset(buf1, 0, sizeof(buf1));
	memset(buf2, 0, sizeof(buf2));
}

void transmitBufData(char msg[]){
	/**
	 * Function to continuously transmit character buffer data
	 *
	 * msg:	character buffer
	 */
	int k = 0;
	while (msg[k] != '\0'){
		sendDataUART4(msg[k++]);
	}
}

void initUART4(uint8_t data_bits, uint8_t stop_bits, bool parity, bool par_type,
			   uint16_t bd_rate){
	/**
	 *	UART4 will be used for sending characters to LCD screen
	 *	PC10 is TX, PC11 is Rx
	 *
	 *	data_bits:	amount of data bits to transmit
	 *	stop_bits: 	amount of stop bits in data
	 *	parity:		parity or no parity
	 *	par_type:	even is FALSE, odd is TRUE
	 *	bd_rate:	baud rate selection
	 */
	// configuring PC10 and PC11 as alt function
	GPIOC->MODER &= ~(3<<20);
	GPIOC->MODER &= ~(3<<22);
	GPIOC->MODER |= (2<<20);
	GPIOC->MODER |= (2<<22);
	// configuring PC10 and PC11 as AF8
	GPIOC->AFR[1] |= (8<<8);
	GPIOC->AFR[1] |= (8<<12);

	/**configuring UART4**/

	// configuring data bits
	switch(data_bits){
		case 8: // for 8 bits, M[1:0]==0b00
			UART4->CR1 &= ~(1<<28);
			UART4->CR1 &= ~(1<<12);
		break;
		case 9: // for 8 bits, M[1:0]==0b01
			UART4->CR1 &= ~(1<<28);
			UART4->CR1 |= (1<<12);
		break;
		case 7: // for 8 bits, M[1:0]==0b10
			UART4->CR1 |= (1<<28);
			UART4->CR1 &= ~(1<<12);
		break;
		default: // default case is 8 bits
			UART4->CR1 &= ~(1<<28);
			UART4->CR1 &= ~(1<<12);
	}
	// configuring baud rate
	// since we are oversampling by 16, formula for BRR is:
	// BRR = clk / usartdiv, where usartdiv is the value we write to BRR reg, so
	UART4->BRR |= (uint16_t)floor(16000000/bd_rate);
	// configuring stop bits
	switch(stop_bits){
		case 1: // for 1 stop bit, STOP[1:0]==0b00
			UART4->CR2 &= ~(3<<12);
		break;
		case 2: // for 2 stop bits, STOP[1:0]==0b10
			UART4->CR2 |= (2<<12);
		break;
		default: // default case is 1 stop bit
			UART4->CR2 &= ~(3<<12);
	}
	// configuring parity
	if(parity){ // if parity is enabled
		UART4->CR1 |= (1<<10); // enable parity
		if(par_type){ // if par_type TRUE, odd parity
			UART4->CR1 |= (1<<9);
		}
		else{ // else, parity is even
			UART4->CR1 &= ~(1<<9);
		}
	}
	else{ // else, disable parity
		UART4->CR1 &= ~(1<<10);
	}
	// enabling UART and transmitter
	UART4->CR1 |= (1<<0) | (1<<3);
}

void sendDataUART4(char data){
	/**
	 * Function used to send a character via UART4
	 *
	 * data:	character to be sent
	 */
	while(!(UART4->ISR&(1<<7))); // wait for TXE bit
	UART4->TDR = data;
}

/**
 * Motor Stuff
 */
// defining motor-related functions
void motorControl(uint8_t moveCode, uint16_t speed){
	/**
	 *	Function to control motors
	 *	dir:		direction of motor (cw or ccw)
	 *	moveCode:	motor select signal
	 *	Motor encoding, pins are step and direction respectively:
	 *	EVEN is cw and ODD is ccw
	 *	Motor0 = moveCode 0 = D0, D1 (cw)
	 *	Motor0 = moveCode 1 = D0, D1 (ccw)
	 *	...
	 */

	moveComplete = false;
	if (bitcheck(GPIOD->ODR,14) == 1){
		bitclear(GPIOD->ODR,14); // Enable Motors
		delay_ms(250);
	}
	switch(moveCode){
		case 0:
			turnMotorx(false, 90, D0, D1, speed);
		break;
		case 1:
			turnMotorx(true, 90, D0, D1, speed);
		break;
		case 2:
			turnMotorx(false, 90, D2, D3, speed);
		break;
		case 3:
			turnMotorx(true, 90, D2, D3, speed);
		break;
		case 4:
			turnMotorx(false, 90, D4, D5, speed);
		break;
		case 5:
			turnMotorx(true, 90, D4, D5, speed);
		break;
		case 6:
			turnMotorx(false, 90, D6, D7, speed);
		break;
		case 7:
			turnMotorx(true, 90, D6, D7, speed);
		break;
		case 8:
			turnMotorx(false, 90, D8, D9, speed);
		break;
		case 9:
			turnMotorx(true, 90, D8, D9, speed);
		break;
		case 10:
			turnMotorx(false, 90, D11, D12, speed);
		break;
		case 11:
			turnMotorx(true, 90, D11, D12, speed);
		break;
		default:
			turnMotorx(false, 0, D0, D1, speed);
	}
}

void turnMotorx(bool direction, uint8_t degrees, uint8_t step_pin, uint8_t dir_pin, uint16_t speed){
	/**
	 * 	Function to turn motor
	 * 	direction:	used to indicate direction of rotation (HIGH=ccw, LOW=cw)
	 * 	degrees:	used to indicate degree of turn
	 * 	step_pin:	pin used to send step pulses
	 * 	dir_pin:	pin used to establish direction
	 */
	// reset count
	count = 0;
	// setting global variables' values
	dir = direction;
	steps = floor(degrees/1.8)*2; // 1 step = 1.8 deg, x2 because total pulse is two toggles
	stepper_pin = step_pin;
	direction_pin = dir_pin;
	TIM3_freq(speed); // default motor speed is 625Hz
}

void TIM3_freq(uint16_t val){
	/**
	 * val:	value of half period in us (for 1kHz freq, val=500)
	 */
	// setting up TIM3 to generate interrupt every val (in us)
	// timer config
	RCC->APB1ENR1 |= (1<<1); // enabling tim3 clock
	TIM3->PSC = 16 - 1; // 1MHz clk, us period
	if (val == 1){ // this way ARR != 0
		TIM3->ARR = 1;
	}
	TIM3->ARR = val - 1; // setting frequency (val is in us)
	TIM3->CCR2 = val - 1; // setting duty cycle to 50% (toggle every count to val)
	TIM3->CNT = 0; // reset counter
	// setting interrupt
	TIM3->DIER |= (1<<0); // enabling Update interrupt (UIE)
	TIM3->CR1 = 1; // enable tim3
}

// defining local functions (base)
void delay_ms(uint32_t val){
    int i;

    /* Configure SysTick */
    SysTick->LOAD = 16000;  /* reload with number of clocks per millisecond */
    SysTick->VAL = 0;       /* clear current value register */
    SysTick->CTRL = 0x5;    /* Enable the timer */

    for(i = 0; i < val; i++) {
        while((SysTick->CTRL & 0x10000) == 0) /* wait until the COUNTFLAG is set */
            { }
    }
    SysTick->CTRL = 0;      /* Stop the timer (Enable = 0) */
}

/**
 * Interrupt Handler Declaration
 */
// Interrupt service routine to be called when TIM3_IRQ is raised
void TIM3_IRQHandler(){
	/**
	 * Interrupt used for motor control, allows generation of step pulses
	 * at set frequency in TIM3_freq()
	 */
	// interrupt is called every x us
	// setting direction pin
	if(dir){ // if dir is true, direction is ccw
		GPIOD->ODR |= (1<<direction_pin);
	}
	else{ // else it's cw
		GPIOD->ODR &= ~(1<<direction_pin);
	}
	// rotation logic
	if(count == steps){ // motor has achieved total turn
		moveComplete = true; // assert done signal
		TIM3->CR1 &= ~(1<<0); // disable timer
	}
	else{ // toggle and update count
		GPIOD->ODR ^= (1<<stepper_pin);
		count++;
	}
	// reset UIF flag
	TIM3->SR &= ~(1<<0);
}

void EXTI13_IRQHandler(){
	/**
	 * Control for User button used as return button for menu
	 * GPIOC13
	 */
	delay_ms(100);
	// return button logic
	switch(state){
		case 0: // MainMenu start
			// do nothing
		break;
		case 1:
			MenuOptions(mainMenu, 0, 1);
			state = 0; // return to main menu
		break;
		case 2:
			MenuOptions(motorOptions, menuCount, menuCount+1);
			state = 2;
		break;
		case 4: // automenu
		break;
		case 8: // Motor Right
			MenuOptions(mainMenu, menuCount, menuCount+1);
			state = 2;
		break;
		case 16: // Motor Left
			cursorControl(NULL);
			motorOptions->menuitems[motorCount]->handler(motorOptions->menuitems[motorCount]);
			cursorControl(motorOptions->menuitems[motorCount]->name);
		break;
		case 32: // Motor Up
			cursorControl(NULL);
			motorOptions->menuitems[motorCount]->handler(motorOptions->menuitems[motorCount]);
			cursorControl(motorOptions->menuitems[motorCount]->name);
		break;
		case 64: // Motor Down
			cursorControl(NULL);
			motorOptions->menuitems[motorCount]->handler(motorOptions->menuitems[motorCount]);
			cursorControl(motorOptions->menuitems[motorCount]->name);
		break;
		case 128: // Motor Front
			cursorControl(NULL);
			motorOptions->menuitems[motorCount]->handler(motorOptions->menuitems[motorCount]);
			cursorControl(motorOptions->menuitems[motorCount]->name);
		break;
		case 256: // Motor Back
			cursorControl(NULL);
			motorOptions->menuitems[motorCount]->handler(motorOptions->menuitems[motorCount]);
			cursorControl(motorOptions->menuitems[motorCount]->name);
		break;
		default:
			state = 0;
	}
	// clear interrupt
	EXTI->RPR1 |= (1<<13);

}

void EXTI1_IRQHandler(){
	/**
	 * Control for right button (RB)
	 * GPIOD1
	 */
	delay_ms(100);
	// check for motor condition
	switch(state){
	case 8: // Motor Right
		motorControl(2, DEFAULT_MOTOR_SPEED);
		while (moveComplete == false); // Wait for move complete
		bitset(GPIOD->ODR,14); // Disable Motors
		state = 8;
	break;
	case 16: // Motor Left
		motorControl(0, DEFAULT_MOTOR_SPEED);
		while (moveComplete == false); // Wait for move complete
		bitset(GPIOD->ODR,14); // Disable Motors
		state = 16;
	break;
	case 32: // Motor Up
		motorControl(4, DEFAULT_MOTOR_SPEED);
		while (moveComplete == false); // Wait for move complete
		bitset(GPIOD->ODR,14); // Disable Motors
		state = 32;
	break;
	case 64: // Motor Down
		motorControl(6, DEFAULT_MOTOR_SPEED);
		while (moveComplete == false); // Wait for move complete
		bitset(GPIOD->ODR,14); // Disable Motors
		state = 64;
	break;
	case 128: // Motor Front
		motorControl(8, DEFAULT_MOTOR_SPEED);
		while (moveComplete == false); // Wait for move complete
		bitset(GPIOD->ODR,14); // Disable Motors
		state = 128;

	break;
	case 256: // Motor Back
		motorControl(10, DEFAULT_MOTOR_SPEED);
		while (moveComplete == false); // Wait for move complete
		bitset(GPIOD->ODR,14); // Disable Motors
		state = 256;
	break;
	default:
		state = state;
}
	// clear interrupt
	EXTI->RPR1 |= (1<<1);
}

void EXTI6_IRQHandler(){
	/**
	 * Control for left button (LB)
	 * GPIOE6
	 */
	delay_ms(100);
	// check for motor condition
	switch(state){
	case 8: // Motor Right
		motorControl(3, DEFAULT_MOTOR_SPEED);
		while (moveComplete == false); // Wait for move complete
		bitset(GPIOD->ODR,14); // Disable Motors
		state = 8;
	break;
	case 16: // Motor Left
		motorControl(1, DEFAULT_MOTOR_SPEED);
		while (moveComplete == false); // Wait for move complete
		bitset(GPIOD->ODR,14); // Disable Motors
		state = 16;
	break;
	case 32: // Motor Up
		motorControl(5, DEFAULT_MOTOR_SPEED);
		while (moveComplete == false); // Wait for move complete
		bitset(GPIOD->ODR,14); // Disable Motors
		state = 32;
	break;
	case 64: // Motor Down
		motorControl(7, DEFAULT_MOTOR_SPEED);
		while (moveComplete == false); // Wait for move complete
		bitset(GPIOD->ODR,14); // Disable Motors
		state = 64;
	break;
	case 128: // Motor Front
		motorControl(9, DEFAULT_MOTOR_SPEED);
		while (moveComplete == false); // Wait for move complete
		bitset(GPIOD->ODR,14); // Disable Motors
		state = 128;
	break;
	case 256: // Motor Back
		motorControl(11, DEFAULT_MOTOR_SPEED);
		while (moveComplete == false); // Wait for move complete
		bitset(GPIOD->ODR,14); // Disable Motors
		state = 256;
	break;
	default:
		state = state;
}
	// clear interrupt
	EXTI->RPR1 |= (1<<6);
}

void EXTI9_IRQHandler(){
	/**
	 * GPIOG9
	 * Control for middle button (MB)
	 */

	delay_ms(100);
	switch(state){
		case 0: // MainMenu start
			if(menuStart){ // start condition
				MenuOptions(mainMenu, 0, 1);
				menuStart = false;
			}
			else{ //
				HelpMenu(); // open help menu
				MenuOptions(mainMenu, menuCount, menuCount+1);
				state = 0; // go back to main menu
			}
		break;
		case 1:
			MenuOptions(mainMenu, 0, 1);
			state = 0; // return to main menu
		break;
		case 2:
			MenuOptions(motorOptions, motorCount, motorCount+1);
			state = 8; // right motor is first motor option
		break;
		case 4: // automenu
			uint8_t image[27648];	//pixel array. 96x96x3
			uint8_t classified_image[27648];	//pixel array. 96x96x3
			RubiksCube cube = {0};

			Cube_Eval(&image, &classified_image, &cube);
		break;
		case 8: // Motor Right
			cursorControl(NULL);
			motorOptions->menuitems[motorCount]->handler(motorOptions->menuitems[motorCount]);
			cursorControl(motorOptions->menuitems[motorCount]->name);
		break;
		case 16: // Motor Left
			cursorControl(NULL);
			motorOptions->menuitems[motorCount]->handler(motorOptions->menuitems[motorCount]);
			cursorControl(motorOptions->menuitems[motorCount]->name);
		break;
		case 32: // Motor Up
			cursorControl(NULL);
			motorOptions->menuitems[motorCount]->handler(motorOptions->menuitems[motorCount]);
			cursorControl(motorOptions->menuitems[motorCount]->name);
		break;
		case 64: // Motor Down
			cursorControl(NULL);
			motorOptions->menuitems[motorCount]->handler(motorOptions->menuitems[motorCount]);
			cursorControl(motorOptions->menuitems[motorCount]->name);
		break;
		case 128: // Motor Front
			cursorControl(NULL);
			motorOptions->menuitems[motorCount]->handler(motorOptions->menuitems[motorCount]);
			cursorControl(motorOptions->menuitems[motorCount]->name);
		break;
		case 256: // Motor Back
			cursorControl(NULL);
			motorOptions->menuitems[motorCount]->handler(motorOptions->menuitems[motorCount]);
			cursorControl(motorOptions->menuitems[motorCount]->name);
		break;
		default:
			state = 0;
	}
	// clear interrupt
	EXTI->RPR1 |= (1<<9);
}

void EXTI10_IRQHandler(){
	/**
	 * Control for down button (DB)
	 * GPIOG10
	 */
	buttons |= (1<<3);
	delay_ms(100);
//	if (menuCount >= NUM_MAIN_MENU_OPTIONS-1){ // max value should be 2 always
//		menuCount = NUM_MAIN_MENU_OPTIONS-1;
//	}
	switch(state){
		case 0: // MainMenu iteration
			menuCount++;
			MenuOptions(mainMenu, menuCount, menuCount+1); // print after help menu
			state = 2;
		break;
		case 2: // MotorOptions
			menuCount++;
			MenuOptions(mainMenu, menuCount, 0);
			state = 4;
		break;
		case 4: // nothing to do if we're at this level

		break;
		case 8:	// Motor Right
			motorCount++;
			MenuOptions(motorOptions, motorCount, motorCount+1);
			state = 16;
		break;
		case 16: // Motor Left
			motorCount++;
			MenuOptions(motorOptions, motorCount, motorCount+1);
			state = 32;
		break;
		case 32: // Motor Up
			motorCount++;
			MenuOptions(motorOptions, motorCount, motorCount+1);
			state = 64;
		break;
		case 64: // Motor Down
			motorCount++;
			MenuOptions(motorOptions, motorCount, motorCount+1);
			state = 128;
		break;
		case 128: // Motor Front
			motorCount++;
			MenuOptions(motorOptions, motorCount, 0);
			state = 256;
		break;
		case 256: // Motor Back
			motorCount++;
		break;
		default:
			state = 0;
	}
	// clear interrupt
	EXTI->RPR1 |= (1<<10);
}

void EXTI15_IRQHandler(){
	/**
	 * Control for up button (UB)
	 * GPIOG15
	 */
	buttons |= (1<<3);
	delay_ms(100);
	if(menuCount <= 0){ // min value should always be 0
		menuCount = 0;
	}
	switch(state){
		case 0: // do nothing in this case
		break;
		case 2: // MotorOptions
			menuCount--; // menuCount = 0
			MenuOptions(mainMenu, menuCount, menuCount+1);
			state = 0;
		break;
		case 4: // go up by one (menuCount == 2) at this point
			menuCount--; // menuCount = 1
			MenuOptions(mainMenu, menuCount, menuCount+1);
			state = 2;
		break;
		case 8:	// Motor Right
			// nothing in this case
		break;
		case 16: // Motor Left
			motorCount--;
			MenuOptions(motorOptions, motorCount, motorCount+1);
			state = 8;
		break;
		case 32: // Motor Up
			motorCount--;
			MenuOptions(motorOptions, motorCount, motorCount+1);
			state = 16;
		break;
		case 64: // Motor Down
			motorCount--;
			MenuOptions(motorOptions, motorCount, motorCount+1);
			state = 32;
		break;
		case 128: // Motor Front
			motorCount--;
			MenuOptions(motorOptions, motorCount, motorCount+1);
			state = 64;
		break;
		case 256: // Motor Back
			motorCount--;
			MenuOptions(motorOptions, motorCount, motorCount+1);
			state = 128;
		break;
		default:
			state = 0;
	}
	// clear interrupt
	EXTI->RPR1 |= (1<<15);
}

void LPUART1_IRQHandler(){

	/**
	  * @brief Handler for LPUART1 interrupts.
	  * @param None
	  * @retval None
	*/


	if (bitcheck(LPUART1->ISR, 5) != 0 ){
        uint8_t read_data = (uint8_t)(LPUART1->RDR); 	// Read the received data from the receiver data register.
        rxBuffer[bufferIndex++] = read_data;          	// Store the received data in the rxBuffer and increment buffer index.
        timeoutCounter = 160000; 						// Reset the timeout counter to its initial value to know when RX transmission is complete.

	}
	else {
		/*if (bitcheck(LPUART1->ISR, 7) != 0){
			LPUART1->TDR = my_name[i++];
		}

		if (my_name[i] == '\0'){
			bitclear(LPUART1->CR1,6);// Disable Transmit Data Empty Interrupt (TXEIE)
			i=0;
		}*/
	}
}

void Error_Handler(void) {
}
