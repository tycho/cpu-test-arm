import os
import re
import subprocess

def subprocess_output(cmdline):
	p = subprocess.Popen(cmdline.split(" "), stdout=subprocess.PIPE)
	stdout, stderr = p.communicate()
	return stdout.rstrip()

def read_whole_file(path):
	f = open(path)
	r = f.read().rstrip()
	f.close()
	return r

def describe_revision():
	if os.path.isdir('.git'):
		#
		# I'd like to use Dulwich or Git-Python to do this, but
		# I concluded that it's highly unlikely that people would
		# have the git repo checked out, but not have git.
		#
		hash = subprocess_output("git rev-parse --verify HEAD")
		tag = subprocess_output("git describe --abbrev=0")
		revs = subprocess_output("git rev-list %s..HEAD" % (tag)).split('\n')
		if len(revs) and revs[0] == '':
			revs = []
		n = len(revs)
		return ('git', tag, n, hash)
	elif os.path.isdir('.hg'):
		#
		# I considered using the Mercurial API directly, but the
		# Mercurial wiki highly discourages it.
		#
		hash = subprocess_output("hg tip --template {node}")
		tag = subprocess_output("hg tip --template {latesttag}")
		n = int(subprocess_output("hg tip --template {latesttagdistance}"))
		return ('hg', tag, n, hash)
	else:
		tag = read_whole_file('tools/release_ver')
		n = 0
		hash = 'no-hash'
		return ('rel', tag, n, hash)

def generate_build_header(**kwargs):
	env = kwargs['env']
	targets = kwargs['target']
	source = kwargs['source']
	scm, tag, n, hash = describe_revision()
	extra = tag.split('-')
	version = map(int, extra[0].split('.'))
	while len(version) < 3:
		version.append(0)
	if n < 1:
		long = "%s" % (tag)
	else:
		long = "%s+%d-%s-%s" % (tag, n, scm, hash[0:8])
	lines = [
		"#ifndef __included_app_build_h\n",
		"#define __included_app_build_h\n",
		"\n",
		"#define APP_VERSION_MAJOR %d\n" % version[0],
		"#define APP_VERSION_MINOR %d\n" % version[1],
		"#define APP_VERSION_REVISION %d\n" % version[2],
		"#define APP_VERSION_BUILD %d\n" % n,
		"#define APP_VERSION_TAG \"%s\"\n" % tag,
		"#define APP_VERSION_LONG \"%s\"\n" % long,
		"\n",
		"#define APP_RESOURCE_VERSION %d,%d,%d,%d\n" % (version[0], version[1], version[2], n),
		"#define APP_RESOURCE_VERSION_STRING \"%d, %d, %d, %d\"\n" % (version[0], version[1], version[2], n),
		"\n",
		"#endif\n"
	]
	for target in targets:
		f = open(str(target), "wb")
		f.writelines(lines)
		f.close()
	return 0

def generate_license_header(**kwargs):
	env = kwargs['env']
	targets = kwargs['target']
	source = kwargs['source']
	source = str(source[0])
	source = open(source, 'rb')
	license = source.read()
	source.close()
	license = re.sub('\t', r'\\t', license)
	license = re.sub('\n', r'\\n', license)
	license = re.sub('"', r'\\"', license)
	lines = [
		"#ifndef __included_app_license_h\n",
		"#define __included_app_license_h\n",
		"\n",
		"#define APP_LICENSE \"%s\"\n" % (license),
		"\n",
		"#endif\n"
	]
	for target in targets:
		f = open(str(target), 'wb')
		f.writelines(lines)
		f.close()

arm = Environment(ENV=os.environ)
thumb = Environment(ENV=os.environ)

debug = ARGUMENTS.get('debug', 0)

for env in [arm, thumb]:
	env.Decider('MD5-timestamp')
	if int(debug):
		env.Append(CFLAGS='-O0 -ggdb')
	else:
		env.Append(CFLAGS='-O2')

	# Architecture defaults to ARMv7-a.
	env.Append(CFLAGS='-march=armv7-a')

	# Basic CFLAGS for correctness
	env.Append(CFLAGS='-std=gnu89 -fno-strict-aliasing')

	# Standard search path
	env.Append(CFLAGS='-I.')

	# Warning flags
	env.Append(CFLAGS='-Wall -Wextra -Wstrict-prototypes -Wold-style-definition -Wmissing-prototypes -Wmissing-declarations -Werror=declaration-after-statement -Werror=implicit-function-declaration')

	# librt is needed for clock_gettime
	env.Append(LIBS='-lrt')

arm.Append(CFLAGS='-marm')
arm.Append(ASFLAGS='-marm')
thumb.Append(CFLAGS='-mthumb')
thumb.Append(ASFLAGS='-mthumb')

sources = [
	'main.c',
	'cpu-arm.S',
	'version.c',
	]

if not env.GetOption('clean'):
	conf = Configure(env)

	if not conf.CheckHeader('getopt.h') or not conf.CheckFunc('getopt_long'):
		conf.env.Append(CFLAGS='-Igetopt')
		sources.append('getopt/getopt_long.c')

	env = conf.Finish()

env.Command('build.h', [Value(describe_revision())], env.Action(generate_build_header, 'Generating build.h'))
env.Command('license.h', '#COPYING', env.Action(generate_license_header, 'Generating license.h'))

for env, name in [(arm, 'arm'), (thumb, 'thumb')]:
	env_sources = [ env.Object(name + '-' + x.split('.')[0] + '.o', x) for x in sources ]
	env.Program(target='cpu_test-' + name, source=env_sources)
