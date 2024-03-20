// Includes ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#include "main.h"
#include "stdbool.h"
#include "stdio.h"

// Some helper macros ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#define bitset(word,   idx)  ((word) |=  (1<<(idx))) //Sets the bit number <idx> -- All other bits are not affected.
#define bitclear(word, idx)  ((word) &= ~(1<<(idx))) //Clears the bit number <idx> -- All other bits are not affected.
#define bitflip(word,  idx)  ((word) ^=  (1<<(idx))) //Flips the bit number <idx> -- All other bits are not affected.
#define bitcheck(word, idx)  ((word>>idx) &   1   ) //Checks the bit number <idx> -- 0 means clear; !0 means set.


//Pre-Declarations of functions. Full declarations are after main(). ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
void InitGPIOA();
void InitDAC();
void InitCOMP();

int main(){

	//Configure GPIOs ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	InitGPIOA();

	//Configure ADC/DAC/COMP/OPAMP ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	InitDAC();
	InitCOMP();





	//Infinite Loop ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	while(1){
		if (bitcheck(COMP1->CSR,30)==1){
			bitset(GPIOA->ODR, 9);		//Red LED - ON
		} else {
			bitclear(GPIOA->ODR, 9);	//Red LED - Off
		}
	}

}

//Function Declarations ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

void InitDAC(){
	/**
	  * @brief Configures DAC1 to output a fixed voltage as comparator reference.
	  * @param None
	  * @retval None
	*/

	bitset(RCC->APB1ENR1, 29);	// Enable Clock to GPIOA
	DAC->DHR12R1 = 1100; 		// Set output to VT+.

	bitclear(DAC->MCR,2); 		// Set DAC Channel 1 to connect to on chip peripherals ('b011).
	bitset(DAC->MCR,1);
	bitset(DAC->MCR,0);

	bitset(DAC->CR,0);			// Enable DAC

}

void InitCOMP(){
	/**
	  * @brief Configures COMP1 to compare DAC output against PA2 analog input.
	  * @param None
	  * @retval None
	*/

	bitset(RCC->APB2ENR , 0);	// Enable Clock to COMP, SYSCFG & VREFBUF

	bitset(COMP1->CSR,8); 		// Set INPSEL = 'b10. PA2
	bitclear(COMP1->CSR,7);

	bitset(COMP1->CSR,6); 		// Set INMSEL = 'b100. DAC Channel 1
	bitclear(COMP1->CSR,5);
	bitclear(COMP1->CSR,4);

	bitset(COMP1->CSR,0); 		//Enable comparator 1.
}

void InitGPIOA(){
	/**
	  * @brief	A function to enable/configure GPIOA.
	  * @param 	N/A.
	  * @retval	N/A
	*/

	bitset(RCC->AHB2ENR, 0);	// Enable Clock to GPIOA

	
	bitset(GPIOA->MODER, 5); 	//Set GPIO Port A, Pin 2 to "Analog Input".
	bitset(GPIOA->MODER, 4);

	
	bitclear(GPIOA->MODER, 19);	//Set GPIO Port A, Pin 9 (RED LED) to "General purpose output mode".
	bitset(GPIOA->MODER, 18);
}


void Error_Handler(void) {
}
