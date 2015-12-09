#include "ClassRegistry.h"
#include <map>
#include <string>
#include <mutex>
#include <vector>
#include <cstring>

#define dladdr __darwin_dladdr
#include <dlfcn.h>

// Needed to fullfil the API contract
typedef std::vector<const char*> string_list;

static std::map<const char*, string_list, charp_comparator> m_imageClasses;
static std::map<const char*, const char*, charp_comparator> m_classToImage;
static string_list m_images;
static std::mutex m_mutex;

void __objc_register_class_with_image(void* mod, const char* name)
{
	Dl_info dli;
	std::map<const char*, string_list, charp_comparator>::iterator it;

	if (dladdr(mod, &dli) == 0)
		return;

	std::lock_guard<std::mutex> _l(m_mutex);
	m_classToImage[name] = dli.dli_fname;
	it = m_imageClasses.find(dli.dli_fname);

	if (it == m_imageClasses.end())
		m_imageClasses[dli.dli_fname] = string_list { name };
	else
	{
		it->second.push_back(name);
		m_images.push_back(dli.dli_fname);
	}
}

const char *class_getImageName(Class cls)
{
	std::lock_guard<std::mutex> _l(m_mutex);
	const char* name;
	std::map<const char*, const char*, charp_comparator>::iterator it;

	name = class_getName(cls);
	it = m_classToImage.find(name);

	if (it != m_classToImage.end())
		return it->second;

	return nullptr;
}

const char **objc_copyClassNamesForImage(const char *image, unsigned int *outCount)
{
	std::map<const char*, string_list, charp_comparator>::iterator it;

	it = m_imageClasses.find(image);
	if (it == m_imageClasses.end())
	{
		*outCount = 0;
		return nullptr;
	}

	*outCount = it->second.size();
	return &it->second[0];
}

const char **objc_copyImageNames(unsigned int *outCount)
{
	*outCount = m_images.size();
	return &m_images[0];
}

