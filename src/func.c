#include <linux/init.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include "func.h"

// Function declaration
void greeting(void);
void farewell(void);

// Function definition
void greeting(void){
    printk(KERN_INFO "Hello world from greeting() in func.c\n");
}

// Function definition
void farewell(void){
    printk(KERN_INFO "Goodbye world from farewell() in func.c\n");
}

// Remove these EXPORT_SYMBOL lines if building as single module
// EXPORT_SYMBOL(greeting);
// EXPORT_SYMBOL(farewell);
