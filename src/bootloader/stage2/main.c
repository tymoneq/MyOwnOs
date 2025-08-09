#include "stdint.h"
#include "stdio.h"

void cstart_(uint16_t bootDrive)
{
    (void)bootDrive;

    putc('c');

    // Test puts function
    puts("Hello world from C!");

    for (;;)
    {
        __asm__ volatile("hlt");
    }
}