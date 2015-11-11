#include "property.h"
#include "../../class.h" // For a bug workaround only
#include "../../properties.h" // ditto

// Fixed in GNUstep r35658
void bug_gnustepFixPropertyCount(Class c)
{
	if (c->properties->count == 0)
		c->properties->count = 1;
}
