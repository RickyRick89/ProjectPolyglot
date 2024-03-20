#include "main.h"


void delay_ms(uint32_t val){
	/**
	  * @brief	A function to delay the program (in milliseconds).
	  *
	  * @param 	val Delay time in ms.
	  *
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

int main(){

	//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Setup ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	// Enable GPIO Ports A, B and C.
	RCC->AHB2ENR |= 0b111;

	//Set GPIO Port A, Pin 9 (RED LED) to "General purpose output mode".
	GPIOA->MODER |= 1<<18;
	GPIOA->MODER &= ~(1<<19);
	//Set GPIO Port B, Pin 7 (BLUE LED) to "General purpose output mode".
	GPIOB->MODER |= 1<<14;
	GPIOB->MODER &= ~(1<<15);
	//Set GPIO Port C, Pin 7 (GREEN LED) to "General purpose output mode".
	GPIOC->MODER |= 1<<14;
	GPIOC->MODER &= ~(1<<15);


	//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Logic ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	// Loop to continuously blink LEDs.
    while(1) {
    	/*
    	// 	Using ODR.
    	//	This takes more cycles since it has to read the value of ODR and perform OR/AND before writing.
    	GPIOA->ODR |= 1<<9;//RED LED - ON
    	GPIOB->ODR |= 1<<7;//BLUE LED - ON
    	GPIOC->ODR |= 1<<7;//GREEN LED - ON
		delay_ms(125);
		GPIOA->ODR &= ~(1<<9);//RED LED - OFF
		delay_ms(125);
    	GPIOA->ODR |= 1<<9;//RED LED - ON
    	GPIOB->ODR &= ~(1<<7);//BLUE LED - OFF
		delay_ms(125);
		GPIOA->ODR &= ~(1<<9);//RED LED - OFF
		delay_ms(125);
    	GPIOA->ODR |= 1<<9;//RED LED - ON
    	GPIOB->ODR |= 1<<7;//BLUE LED - ON
    	GPIOC->ODR &= ~(1<<7);//GREEN LED - OFF
		delay_ms(125);
		GPIOA->ODR &= ~(1<<9);//RED LED - OFF
		delay_ms(125);
    	GPIOA->ODR |= 1<<9;//RED LED - ON
    	GPIOB->ODR &= ~(1<<7);//BLUE LED - OFF
		delay_ms(125);
		GPIOA->ODR &= ~(1<<9);//RED LED - OFF
		delay_ms(125);
		*/

    	//	Using BSRR.
    	// 	This doesn't require a read, only write.
    	GPIOA->BSRR = 1<<9;//RED LED - ON
    	GPIOB->BSRR = 1<<7;//BLUE LED - ON
    	GPIOC->BSRR = 1<<7;//GREEN LED - ON
		delay_ms(125);
		GPIOA->BSRR = 1<<25;//RED LED - OFF
		delay_ms(125);
    	GPIOA->BSRR = 1<<9;//RED LED - ON
    	GPIOB->BSRR = 1<<23;//BLUE LED - OFF
		delay_ms(125);
		GPIOA->BSRR = 1<<25;//RED LED - OFF
		delay_ms(125);
    	GPIOA->BSRR = 1<<9;//RED LED - ON
    	GPIOB->BSRR = 1<<7;//BLUE LED - ON
    	GPIOC->BSRR = 1<<23;//GREEN LED - OFF
		delay_ms(125);
		GPIOA->BSRR = 1<<25;//RED LED - OFF
		delay_ms(125);
    	GPIOA->BSRR = 1<<9;//RED LED - ON
    	GPIOB->BSRR = 1<<23;//BLUE LED - OFF
		delay_ms(125);
		GPIOA->BSRR = 1<<25;//RED LED - OFF
		delay_ms(125);
    }


	//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Testing ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	//HAL_Init();
	//uint32_t startTick = HAL_GetTick();
	//delay_ms(125)
	//uint32_t endTick = HAL_GetTick();

}

void Error_Handler(void) {
}
