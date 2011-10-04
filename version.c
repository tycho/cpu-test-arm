#include "prefix.h"

#include "build.h"
#include "license.h"
#include "version.h"

#include <stdio.h>

void license(void)
{
	puts(APP_LICENSE);
}

const char *app_version_short(void)
{
	return APP_VERSION_TAG;
}

const char *app_version_long(void)
{
	return APP_VERSION_LONG;
}

int app_version_major(void)
{
	return APP_VERSION_MAJOR;
}

int app_version_minor(void)
{
	return APP_VERSION_MINOR;
}

int app_version_revison(void)
{
	return APP_VERSION_REVISION;
}

int app_version_build(void)
{
	return APP_VERSION_BUILD;
}
