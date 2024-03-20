// Includes ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#include "main.h"
#include "stdbool.h"
#include "stdio.h"
#include "math.h"

// Some helper macros ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#define bitset(word,   idx)  ((word) |=  (1<<(idx))) //Sets the bit number <idx> -- All other bits are not affected.
#define bitclear(word, idx)  ((word) &= ~(1<<(idx))) //Clears the bit number <idx> -- All other bits are not affected.
#define bitflip(word,  idx)  ((word) ^=  (1<<(idx))) //Flips the bit number <idx> -- All other bits are not affected.
#define bitcheck(word, idx)  ((word>>idx) &   1   ) //Checks the bit number <idx> -- 0 means clear; !0 means set.


//Pre-Declarations of functions. Full declarations are after main(). ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
void InitGPIOA();
void InitGPIOC();
void InitGPIOG();
void InitDAC();
void InitADC();
void InitTIM2();
void InitTIM3();
void InitLPUART1(uint32_t baud, uint8_t stop, uint8_t data_len, bool parity_en, bool parity_odd);
void LPUART1write();
void myprint();
void Delay_ms();

//Global Variables ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
uint32_t step=0;								// Incrementing variable to track step of sine wave.

int main(){

	//Configure GPIOs ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	InitGPIOA();
	InitGPIOC();
	InitGPIOG();

	//Configure Timers ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	bitset(RCC->CFGR, 0);     				// Use HSI16 as SYSCLK
	InitTIM2();
	InitTIM3();

	//Configure LPUART1 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	InitLPUART1(115200,1,8,false,false);	//InitLPUART1(baud, stop, data_len, parity_en, parity_odd)

	//Configure ADC/DAC/COMP/OPAMP ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	InitDAC();
	InitADC();





	//Infinite Loop ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	while(1);

}

//Function Declarations ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

void Delay_ms(uint32_t val){
	/**
	  * @brief	A function to delay the program (in milliseconds).
	  * @param 	val Delay time in ms.
	  * @retval	N/A
	*/

	// Convert desired ms (val) to a loop count.
	float count = val * 282.398124876451;

	// Loop to delay program.
	int x = 0;
	while(x < count){
		x += 1;
	}
}

void myprint (char msg[]){
	/**
	 * @brief Sends a string over LPUART1 by transmitting each character until the null terminator is reached. This function is used for sending messages via LPUART1 to facilitate debugging or communication over serial.
	 * @param msg A pointer to the character array (string) that will be sent over LPUART1. The string must be null-terminated.
	 * @retval None
	*/

    uint8_t idx=0;

    // Loop through each character in the string.
    while(msg[idx]!='\0')
    {
    	LPUART1write(msg[idx++]);
    }
}

void LPUART1write (int ch) {
	/**
	  * @brief Transmits a single character over LPUART1. It waits for the transmit data register to be empty (indicating the UART is ready to transmit the next character) before sending the character. This function is a fundamental building block for serial communication over LPUART1.
	  * @param ch The character to be transmitted over LPUART1. Although the parameter is an integer, only the least significant byte (LSB) will be sent.
	  * @retval None
	*/

    while (!(LPUART1->ISR & 0x0080)); 	// wait until Tx buffer empty
    LPUART1->TDR = (ch & 0xFF);			// Write character to the Transmit Data Register (TDR).
}

void InitADC(){
	/**
	  * @brief Sets up the Analog-to-Digital Converter (ADC) with specific configurations for regular and injected conversions.
	  * @param  None
	  * @retval None
	*/

	bitset(RCC->AHB2ENR, 13);  	// Enable ADC clock
	RCC->CCIPR1 |=0x3<<28;     	// Set ADC Clock to SYSCLK

	bitclear(ADC1->CR, 29);  	// Disable deep power down
    bitset(ADC1->CR, 28);		// Enable voltage regulator

    bitset(ADC1->IER,2);		// Enable EOCIE (end of conversion interrupt enable).

    bitset(ADC1->CFGR,   12);	// Enable OVRMOD. New value will overwrite in case of overrun.

    bitclear(ADC1->CFGR, 11);	// EXTEN=01 (Rising edge trigger)
    bitset(ADC1->CFGR,   10);

    bitclear(ADC1->CFGR, 9); 	//EXTSEL=0011 (TIM2_CH2)
    bitclear(ADC1->CFGR, 8);
    bitset(ADC1->CFGR, 7);
    bitset(ADC1->CFGR, 6);


	bitclear(ADC1->SQR1,10);	//SQ1=00001 (IN1). PC0 is ADC1_IN1
	bitclear(ADC1->SQR1,9);
	bitclear(ADC1->SQR1,8);
	bitclear(ADC1->SQR1,7);
	bitset(ADC1->SQR1,6);


	bitclear(ADC1->SQR1,3);		//L=0000 (1 channel)
	bitclear(ADC1->SQR1,2);
	bitclear(ADC1->SQR1,1);
	bitclear(ADC1->SQR1,0);

    Delay_ms(10);				// Wait for the voltage regulator to stabilize

    bitset(ADC1->CR,0);         // Enable ADC
    bitset(ADC1->CR,2);         // Start regular conversion

	while(bitcheck(ADC1->ISR, 0)==0);	// Wait until ADC is Ready (ADRDY)

	NVIC_SetPriority(ADC1_2_IRQn, 1); 	// 0 is higher than 1 (3 bit priority)

	NVIC_EnableIRQ(ADC1_2_IRQn);		// Enable ADC interrupt.
}

void InitDAC(){
	/**
	  * @brief Initializes the Digital-to-Analog Converter (DAC) and sets a starting output value.
	  * @param None
	  * @retval None
	*/

	bitset(RCC->APB1ENR1, 29);	// Enable Clock to GPIOA
	DAC->DHR12R1 = 0; 			// Set output to zero.
	bitset(DAC->CR,0);			// Enable DAC

}

void InitGPIOA(){
	/**
	  * @brief	A function to enable/configure GPIOA.
	  * @param 	N/A.
	  * @retval	N/A
	*/

	bitset(RCC->AHB2ENR, 0);	// Enable Clock to GPIOA

	
	bitset(GPIOA->MODER, 8);	//Set GPIO Port A, Pin 4 to "Analog mode".
	bitset(GPIOA->MODER, 9);
}

void InitGPIOC(){
	/**
	  * @brief	A function to enable/configure GPIOC.
	  * @param 	None
	  * @retval	None
	*/

	bitset(RCC->AHB2ENR, 2);	// Enable Clock to GPIOC

	
    bitset(GPIOC->MODER, 0);	//Set GPIO Port C, Pin 0 to "Analog mode".
    bitset(GPIOC->MODER, 1);
}

void InitGPIOG(){
	/**
	  * @brief	A function to enable/configure GPIOG.
	  * @param 	None
	  * @retval	None
	*/

	bitset(RCC->AHB2ENR,   6);  	// Enable Clock to GPIOG
	bitset(RCC->APB1ENR1, 28);  	// Enable Clock to PWR Interface
	bitset(PWR->CR2, 9);        	// Enable GPIOG power

	//Set GPIOG.7 to AF8 (LPUART1_TX)
	bitset(GPIOG->MODER,    15);  	// Setting 0b10 (Alternate Function) in pin 7 two bit mode cfgs
	bitclear(GPIOG->MODER,  14);

	bitset(GPIOG->AFR[0],   31);  	// Programming 0b1000 (AF8 = LPUART1_TX)
	bitclear(GPIOG->AFR[0], 30);
	bitclear(GPIOG->AFR[0], 29);
	bitclear(GPIOG->AFR[0], 28);

	//Set GPIOG.8 to AF8 (LPUART1_RX)
	bitset(GPIOG->MODER,    17);  	// Setting 0b10 (Alternate Function) in pin 8 two bit mode cfgs
	bitclear(GPIOG->MODER,  16);

	bitset(GPIOG->AFR[1], 3);  		// Programming 0b1000 (AF8 = LPUART1_RX)
	bitclear(GPIOG->AFR[1], 2);
	bitclear(GPIOG->AFR[1], 1);
	bitclear(GPIOG->AFR[1], 0);

}

void InitTIM2(){
	/**
	  * @brief Initializes TIM2 timer.
	  * @param None
	  * @retval None
	*/
	bitset(RCC->APB1ENR1, 0);	// enable TIM2 clock
	TIM2->PSC = 16 - 1;     	// Set Prescale to get 1MHz
	TIM2->ARR = 400 - 1;   		// Toggle every 400us
	TIM2->CNT = 0;             	// Clear counter
	bitset(TIM2->CR1,4); 		// Set direction to down.

	bitclear(TIM2->CCMR1,14); 	//Configure channel 2 to toggle
	bitset(TIM2->CCMR1,13);
	bitset(TIM2->CCMR1,12);

	TIM2->CCR2= 0; 				//Initial value for channel 2
	bitset(TIM2->CCER,4);		//Enable channel 2


	bitset(TIM2->CR1,0);		// Enable TIM2.
}



void InitTIM3(){
	/**
	  * @brief Initializes TIM3 timer for periodic interrupts.
	  * @param None
	  * @retval None
	*/


	bitset(RCC->APB1ENR1,1); 	//Enable TIM3

	TIM3->PSC = 16-1;			// Set prescale value to get 1MHz.
	TIM3->ARR = 10-1;			// Count 10us
	bitset(TIM3->CR1,4); 		// Set direction to down.
	TIM3->CNT = 0;             	// Clear counter
	bitset(TIM3->DIER, 0);    	// Set Update Interrupt Enable
	bitset(TIM3->CR1,0); 		// Set direction to down.

	//	3- Setup Interrupt Priority
	NVIC_SetPriority(TIM3_IRQn, 0); // 0 is higher than 1 (3 bit priority)

	//	5- Enable IRQ in NVIC
	NVIC_EnableIRQ(TIM3_IRQn);
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
	bitset(LPUART1->CR1,3);// Enable Transmitter
	bitset(LPUART1->CR1,2);// Enable Receiver
	bitset(LPUART1->CR1,0);// Enable LPUART1

}

void TIM3_IRQHandler(){
	/**
	  * @brief Handler for TIM3 interrupts.
	  * @param None
	  * @retval None
	*/

	int dac_val_12b=(4095/2)*(1+sin(2*3.14*step/99)); // where step is 0 to 99

	DAC->DHR12R1 = dac_val_12b; // Set output to zero.

	step = step + 1;
	if (step >= 100){
		step = 0;
	}

	bitclear(TIM3->SR, 0); // Clear flag
}

void ADC1_2_IRQHandler(){
	/**
	  * @brief ADC1 and ADC2 interrupt handler for handling conversion complete events.
	  * @param  None
	  * @retval None
	*/

	char  txt [20];

	float adc_val = (ADC1->DR);						// Read regular ADC value
	float voltage = ((adc_val/4095)*3.3); 			// Convert ADC code to volts.


	sprintf(txt, "$%.02f;",  voltage);				// Format output string.
	myprint(txt);

}


void Error_Handler(void) {
}
