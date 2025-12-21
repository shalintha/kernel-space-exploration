#include <linux/kernel.h>
#include <linux/module.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Shalintha Silva");
MODULE_DESCRIPTION("A simple hello world module");

static int __init hello_init(void) {
    // printk(KERN_INFO "%s: Hello, world!, From init\n", __func__);
    pr_info("%s: Hello, world!, From init\n", __func__);
    return 0;
}

static void __exit hello_exit(void) {
    printk(KERN_INFO "%s: Goodbye, world!, From exit\n", __func__);
}

module_init(hello_init);
module_exit(hello_exit);
