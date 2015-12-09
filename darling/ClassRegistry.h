#ifndef CLASSREGISTRY_H
#define CLASSREGISTRY_H
#include <objc/runtime.h>
#include <cstring>

extern "C" {

void __objc_register_class_with_image(void* mod, const char* name);
const char *class_getImageName(Class cls);
const char **objc_copyClassNamesForImage(const char *image, unsigned int *outCount);
const char **objc_copyImageNames(unsigned int *outCount);

}

struct charp_comparator
{
	bool operator()(const char *a, const char *b) const
	{
		return std::strcmp(a, b) < 0;
	}
};

#endif


