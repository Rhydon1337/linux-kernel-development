#include <linux/module.h> /* Needed by all modules */
#include <linux/kernel.h> /* Needed for KERN_INFO  */
#include <linux/init.h>   /* Needed for macros     */

MODULE_LICENSE("GPL"); // required

static int __init lkm_init(void)
{
 printk(KERN_INFO "Hello world!\n");
 /*
 * A non 0 return means init_module failed; module can't be loaded.
 */
 return 0;
}

static void __exit lkm_exit(void)
{
 printk(KERN_INFO "Goodbye world!\n");
}

module_init(lkm_init);
module_exit(lkm_exit);