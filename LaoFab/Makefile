# This Makefile is for the LaoFab extension to perl.
#
# It was generated automatically by MakeMaker version
# 6.42 (Revision: 41145) from the contents of
# Makefile.PL. Don't edit this file, edit Makefile.PL instead.
#
#       ANY CHANGES MADE HERE WILL BE LOST!
#
#   MakeMaker ARGV: ()
#
#   MakeMaker Parameters:

#     ABSTRACT => q[Catalyst based application]
#     AUTHOR => q[Joakim Lagerqvist]
#     DIR => []
#     DISTNAME => q[LaoFab]
#     EXE_FILES => [q[script/laofab_cgi.pl], q[script/laofab_create.pl], q[script/laofab_fastcgi.pl], q[script/laofab_server.pl], q[script/laofab_test.pl], q[script/laofab_update_schema.pl]]
#     NAME => q[LaoFab]
#     NO_META => q[1]
#     PL_FILES => {  }
#     PREREQ_PM => { parent=>q[0], Catalyst::Plugin::Static::Simple=>q[0], Config::General=>q[0], Catalyst::Plugin::ConfigLoader=>q[0], ExtUtils::MakeMaker=>q[6.42], Catalyst::Runtime=>q[5.71000], Catalyst::Action::RenderView=>q[0] }
#     VERSION => q[0.01]
#     dist => { PREOP=>q[$(PERL) -I. "-MModule::Install::Admin" -e "dist_preop(q($(DISTVNAME)))"] }
#     realclean => { FILES=>q[MYMETA.yml] }
#     test => { TESTS=>q[t/01app.t t/02pod.t t/03podcoverage.t t/controller_Export.t t/controller_Feed.t t/controller_Manage.t t/controller_Page.t t/controller_REST.t t/controller_Search.t t/controller_Stats.t t/controller_User.t t/live_login.t t/model_DB.t t/view_Email-Template.t t/view_Email.t t/view_JSON.t] }

# --- MakeMaker post_initialize section:


# --- MakeMaker const_config section:

# These definitions are from config.sh (via /usr/local/lib/perl5/5.10.0/darwin-2level/Config.pm)

# They may have been overridden via Makefile.PL or on the command line
AR = ar
CC = cc
CCCDLFLAGS =  
CCDLFLAGS =  
DLEXT = bundle
DLSRC = dl_dlopen.xs
EXE_EXT = 
FULL_AR = /usr/bin/ar
LD = env MACOSX_DEPLOYMENT_TARGET=10.3 cc
LDDLFLAGS =  -bundle -undefined dynamic_lookup -L/opt/local/lib
LDFLAGS =  -L/opt/local/lib
LIBC = /usr/lib/libc.dylib
LIB_EXT = .a
OBJ_EXT = .o
OSNAME = darwin
OSVERS = 9.6.2
RANLIB = ranlib
SITELIBEXP = /usr/local/lib/perl5/site_perl/5.10.0
SITEARCHEXP = /usr/local/lib/perl5/site_perl/5.10.0/darwin-2level
SO = dylib
VENDORARCHEXP = 
VENDORLIBEXP = 


# --- MakeMaker constants section:
AR_STATIC_ARGS = cr
DIRFILESEP = /
DFSEP = $(DIRFILESEP)
NAME = LaoFab
NAME_SYM = LaoFab
VERSION = 0.01
VERSION_MACRO = VERSION
VERSION_SYM = 0_01
DEFINE_VERSION = -D$(VERSION_MACRO)=\"$(VERSION)\"
XS_VERSION = 0.01
XS_VERSION_MACRO = XS_VERSION
XS_DEFINE_VERSION = -D$(XS_VERSION_MACRO)=\"$(XS_VERSION)\"
INST_ARCHLIB = blib/arch
INST_SCRIPT = blib/script
INST_BIN = blib/bin
INST_LIB = blib/lib
INST_MAN1DIR = blib/man1
INST_MAN3DIR = blib/man3
MAN1EXT = 1
MAN3EXT = 3
INSTALLDIRS = site
DESTDIR = 
PREFIX = $(SITEPREFIX)
PERLPREFIX = /usr/local
SITEPREFIX = /usr/local
VENDORPREFIX = 
INSTALLPRIVLIB = /usr/local/lib/perl5/5.10.0
DESTINSTALLPRIVLIB = $(DESTDIR)$(INSTALLPRIVLIB)
INSTALLSITELIB = /usr/local/lib/perl5/site_perl/5.10.0
DESTINSTALLSITELIB = $(DESTDIR)$(INSTALLSITELIB)
INSTALLVENDORLIB = 
DESTINSTALLVENDORLIB = $(DESTDIR)$(INSTALLVENDORLIB)
INSTALLARCHLIB = /usr/local/lib/perl5/5.10.0/darwin-2level
DESTINSTALLARCHLIB = $(DESTDIR)$(INSTALLARCHLIB)
INSTALLSITEARCH = /usr/local/lib/perl5/site_perl/5.10.0/darwin-2level
DESTINSTALLSITEARCH = $(DESTDIR)$(INSTALLSITEARCH)
INSTALLVENDORARCH = 
DESTINSTALLVENDORARCH = $(DESTDIR)$(INSTALLVENDORARCH)
INSTALLBIN = /usr/local/bin
DESTINSTALLBIN = $(DESTDIR)$(INSTALLBIN)
INSTALLSITEBIN = /usr/local/bin
DESTINSTALLSITEBIN = $(DESTDIR)$(INSTALLSITEBIN)
INSTALLVENDORBIN = 
DESTINSTALLVENDORBIN = $(DESTDIR)$(INSTALLVENDORBIN)
INSTALLSCRIPT = /usr/local/bin
DESTINSTALLSCRIPT = $(DESTDIR)$(INSTALLSCRIPT)
INSTALLSITESCRIPT = /usr/local/bin
DESTINSTALLSITESCRIPT = $(DESTDIR)$(INSTALLSITESCRIPT)
INSTALLVENDORSCRIPT = 
DESTINSTALLVENDORSCRIPT = $(DESTDIR)$(INSTALLVENDORSCRIPT)
INSTALLMAN1DIR = /usr/local/man/man1
DESTINSTALLMAN1DIR = $(DESTDIR)$(INSTALLMAN1DIR)
INSTALLSITEMAN1DIR = /usr/local/man/man1
DESTINSTALLSITEMAN1DIR = $(DESTDIR)$(INSTALLSITEMAN1DIR)
INSTALLVENDORMAN1DIR = 
DESTINSTALLVENDORMAN1DIR = $(DESTDIR)$(INSTALLVENDORMAN1DIR)
INSTALLMAN3DIR = /usr/local/man/man3
DESTINSTALLMAN3DIR = $(DESTDIR)$(INSTALLMAN3DIR)
INSTALLSITEMAN3DIR = /usr/local/man/man3
DESTINSTALLSITEMAN3DIR = $(DESTDIR)$(INSTALLSITEMAN3DIR)
INSTALLVENDORMAN3DIR = 
DESTINSTALLVENDORMAN3DIR = $(DESTDIR)$(INSTALLVENDORMAN3DIR)
PERL_LIB =
PERL_ARCHLIB = /usr/local/lib/perl5/5.10.0/darwin-2level
LIBPERL_A = libperl.a
FIRST_MAKEFILE = Makefile
MAKEFILE_OLD = Makefile.old
MAKE_APERL_FILE = Makefile.aperl
PERLMAINCC = $(CC)
PERL_INC = /usr/local/lib/perl5/5.10.0/darwin-2level/CORE
PERL = /usr/local/bin/perl "-Iinc"
FULLPERL = /usr/local/bin/perl "-Iinc"
ABSPERL = $(PERL)
PERLRUN = $(PERL)
FULLPERLRUN = $(FULLPERL)
ABSPERLRUN = $(ABSPERL)
PERLRUNINST = $(PERLRUN) "-I$(INST_ARCHLIB)" "-Iinc" "-I$(INST_LIB)"
FULLPERLRUNINST = $(FULLPERLRUN) "-I$(INST_ARCHLIB)" "-Iinc" "-I$(INST_LIB)"
ABSPERLRUNINST = $(ABSPERLRUN) "-I$(INST_ARCHLIB)" "-Iinc" "-I$(INST_LIB)"
PERL_CORE = 0
PERM_RW = 644
PERM_RWX = 755

MAKEMAKER   = /usr/local/lib/perl5/5.10.0/ExtUtils/MakeMaker.pm
MM_VERSION  = 6.42
MM_REVISION = 41145

# FULLEXT = Pathname for extension directory (eg Foo/Bar/Oracle).
# BASEEXT = Basename part of FULLEXT. May be just equal FULLEXT. (eg Oracle)
# PARENT_NAME = NAME without BASEEXT and no trailing :: (eg Foo::Bar)
# DLBASE  = Basename part of dynamic library. May be just equal BASEEXT.
MAKE = make
FULLEXT = LaoFab
BASEEXT = LaoFab
PARENT_NAME = 
DLBASE = $(BASEEXT)
VERSION_FROM = 
OBJECT = 
LDFROM = $(OBJECT)
LINKTYPE = dynamic
BOOTDEP = 

# Handy lists of source code files:
XS_FILES = 
C_FILES  = 
O_FILES  = 
H_FILES  = 
MAN1PODS = script/laofab_cgi.pl \
	script/laofab_create.pl \
	script/laofab_fastcgi.pl \
	script/laofab_server.pl \
	script/laofab_test.pl
MAN3PODS = lib/LaoFab.pm \
	lib/LaoFab/Controller/Document.pm \
	lib/LaoFab/Controller/Export.pm \
	lib/LaoFab/Controller/Feed.pm \
	lib/LaoFab/Controller/Folder.pm \
	lib/LaoFab/Controller/Manage.pm \
	lib/LaoFab/Controller/Page.pm \
	lib/LaoFab/Controller/REST.pm \
	lib/LaoFab/Controller/Root.pm \
	lib/LaoFab/Controller/Search.pm \
	lib/LaoFab/Controller/Stats.pm \
	lib/LaoFab/Controller/User.pm \
	lib/LaoFab/Model/DB.pm \
	lib/LaoFab/View/EXCEL.pm \
	lib/LaoFab/View/Email.pm \
	lib/LaoFab/View/Email/Template.pm \
	lib/LaoFab/View/HTML.pm \
	lib/LaoFab/View/JSON.pm \
	lib/LaoFab/View/TT/NoWrap.pm

# Where is the Config information that we are using/depend on
CONFIGDEP = $(PERL_ARCHLIB)$(DFSEP)Config.pm $(PERL_INC)$(DFSEP)config.h

# Where to build things
INST_LIBDIR      = $(INST_LIB)
INST_ARCHLIBDIR  = $(INST_ARCHLIB)

INST_AUTODIR     = $(INST_LIB)/auto/$(FULLEXT)
INST_ARCHAUTODIR = $(INST_ARCHLIB)/auto/$(FULLEXT)

INST_STATIC      = 
INST_DYNAMIC     = 
INST_BOOT        = 

# Extra linker info
EXPORT_LIST        = 
PERL_ARCHIVE       = 
PERL_ARCHIVE_AFTER = 


TO_INST_PM = lib/LaoFab.pm \
	lib/LaoFab/.DS_Store \
	lib/LaoFab/Controller/.DS_Store \
	lib/LaoFab/Controller/Document.pm \
	lib/LaoFab/Controller/Export.pm \
	lib/LaoFab/Controller/Feed.pm \
	lib/LaoFab/Controller/Folder.pm \
	lib/LaoFab/Controller/Manage.pm \
	lib/LaoFab/Controller/Page.pm \
	lib/LaoFab/Controller/REST.pm \
	lib/LaoFab/Controller/Root.pm \
	lib/LaoFab/Controller/Search.pm \
	lib/LaoFab/Controller/Stats.pm \
	lib/LaoFab/Controller/User.pm \
	lib/LaoFab/Model/DB.pm \
	lib/LaoFab/Model/DB.pm.new \
	lib/LaoFab/ResultSet/Documents.pm \
	lib/LaoFab/Schema.pm \
	lib/LaoFab/Schema/Albums.pm \
	lib/LaoFab/Schema/Authors.pm \
	lib/LaoFab/Schema/Buzz1.pm \
	lib/LaoFab/Schema/Buzz2.pm \
	lib/LaoFab/Schema/Buzz3.pm \
	lib/LaoFab/Schema/Comments.pm \
	lib/LaoFab/Schema/Content.pm \
	lib/LaoFab/Schema/Doctypes.pm \
	lib/LaoFab/Schema/DocumentFolder.pm \
	lib/LaoFab/Schema/DocumentSubcat.pm \
	lib/LaoFab/Schema/Documents.pm \
	lib/LaoFab/Schema/Downloads.pm \
	lib/LaoFab/Schema/FirstPage.pm \
	lib/LaoFab/Schema/Folders.pm \
	lib/LaoFab/Schema/Keywords.pm \
	lib/LaoFab/Schema/Logins.pm \
	lib/LaoFab/Schema/Mimes.pm \
	lib/LaoFab/Schema/PhotoAlbum.pm \
	lib/LaoFab/Schema/Photos.pm \
	lib/LaoFab/Schema/Phrases.pm \
	lib/LaoFab/Schema/Role.pm \
	lib/LaoFab/Schema/Roles.pm \
	lib/LaoFab/Schema/Sessions.pm \
	lib/LaoFab/Schema/Subcats.pm \
	lib/LaoFab/Schema/Tags.pm \
	lib/LaoFab/Schema/User.pm \
	lib/LaoFab/Schema/UserRole.pm \
	lib/LaoFab/Schema/UserRole.pm.org \
	lib/LaoFab/Schema/Users.pm \
	lib/LaoFab/Test/Database/Live.pm \
	lib/LaoFab/View/.DS_Store \
	lib/LaoFab/View/EXCEL.pm \
	lib/LaoFab/View/Email.pm \
	lib/LaoFab/View/Email/Template.pm \
	lib/LaoFab/View/HTML.pm \
	lib/LaoFab/View/JSON.pm \
	lib/LaoFab/View/TT/NoWrap.pm

PM_TO_BLIB = lib/LaoFab/ResultSet/Documents.pm \
	blib/lib/LaoFab/ResultSet/Documents.pm \
	lib/LaoFab/Schema/Tags.pm \
	blib/lib/LaoFab/Schema/Tags.pm \
	lib/LaoFab/Schema/Buzz3.pm \
	blib/lib/LaoFab/Schema/Buzz3.pm \
	lib/LaoFab/Controller/REST.pm \
	blib/lib/LaoFab/Controller/REST.pm \
	lib/LaoFab/Schema/Buzz2.pm \
	blib/lib/LaoFab/Schema/Buzz2.pm \
	lib/LaoFab/View/TT/NoWrap.pm \
	blib/lib/LaoFab/View/TT/NoWrap.pm \
	lib/LaoFab/.DS_Store \
	blib/lib/LaoFab/.DS_Store \
	lib/LaoFab/Schema/Documents.pm \
	blib/lib/LaoFab/Schema/Documents.pm \
	lib/LaoFab/Test/Database/Live.pm \
	blib/lib/LaoFab/Test/Database/Live.pm \
	lib/LaoFab/Schema/Roles.pm \
	blib/lib/LaoFab/Schema/Roles.pm \
	lib/LaoFab/Schema/Downloads.pm \
	blib/lib/LaoFab/Schema/Downloads.pm \
	lib/LaoFab/Schema.pm \
	blib/lib/LaoFab/Schema.pm \
	lib/LaoFab/View/HTML.pm \
	blib/lib/LaoFab/View/HTML.pm \
	lib/LaoFab/Controller/Root.pm \
	blib/lib/LaoFab/Controller/Root.pm \
	lib/LaoFab/Controller/.DS_Store \
	blib/lib/LaoFab/Controller/.DS_Store \
	lib/LaoFab/Controller/Feed.pm \
	blib/lib/LaoFab/Controller/Feed.pm \
	lib/LaoFab/Schema/Photos.pm \
	blib/lib/LaoFab/Schema/Photos.pm \
	lib/LaoFab/Controller/Page.pm \
	blib/lib/LaoFab/Controller/Page.pm \
	lib/LaoFab/Controller/User.pm \
	blib/lib/LaoFab/Controller/User.pm \
	lib/LaoFab/Schema/Content.pm \
	blib/lib/LaoFab/Schema/Content.pm \
	lib/LaoFab/View/Email.pm \
	blib/lib/LaoFab/View/Email.pm \
	lib/LaoFab/Schema/DocumentSubcat.pm \
	blib/lib/LaoFab/Schema/DocumentSubcat.pm \
	lib/LaoFab/Schema/UserRole.pm.org \
	blib/lib/LaoFab/Schema/UserRole.pm.org \
	lib/LaoFab/View/EXCEL.pm \
	blib/lib/LaoFab/View/EXCEL.pm \
	lib/LaoFab/Controller/Document.pm \
	blib/lib/LaoFab/Controller/Document.pm \
	lib/LaoFab/Schema/User.pm \
	blib/lib/LaoFab/Schema/User.pm \
	lib/LaoFab/Schema/Logins.pm \
	blib/lib/LaoFab/Schema/Logins.pm \
	lib/LaoFab/Schema/Folders.pm \
	blib/lib/LaoFab/Schema/Folders.pm \
	lib/LaoFab/Schema/FirstPage.pm \
	blib/lib/LaoFab/Schema/FirstPage.pm \
	lib/LaoFab/Model/DB.pm \
	blib/lib/LaoFab/Model/DB.pm \
	lib/LaoFab/Schema/Doctypes.pm \
	blib/lib/LaoFab/Schema/Doctypes.pm \
	lib/LaoFab/View/Email/Template.pm \
	blib/lib/LaoFab/View/Email/Template.pm \
	lib/LaoFab/Schema/Comments.pm \
	blib/lib/LaoFab/Schema/Comments.pm \
	lib/LaoFab/View/JSON.pm \
	blib/lib/LaoFab/View/JSON.pm \
	lib/LaoFab/Schema/PhotoAlbum.pm \
	blib/lib/LaoFab/Schema/PhotoAlbum.pm \
	lib/LaoFab/Controller/Export.pm \
	blib/lib/LaoFab/Controller/Export.pm \
	lib/LaoFab/Schema/Albums.pm \
	blib/lib/LaoFab/Schema/Albums.pm \
	lib/LaoFab/Schema/DocumentFolder.pm \
	blib/lib/LaoFab/Schema/DocumentFolder.pm \
	lib/LaoFab/View/.DS_Store \
	blib/lib/LaoFab/View/.DS_Store \
	lib/LaoFab/Schema/Role.pm \
	blib/lib/LaoFab/Schema/Role.pm \
	lib/LaoFab/Schema/Buzz1.pm \
	blib/lib/LaoFab/Schema/Buzz1.pm \
	lib/LaoFab/Schema/Mimes.pm \
	blib/lib/LaoFab/Schema/Mimes.pm \
	lib/LaoFab/Model/DB.pm.new \
	blib/lib/LaoFab/Model/DB.pm.new \
	lib/LaoFab/Schema/Users.pm \
	blib/lib/LaoFab/Schema/Users.pm \
	lib/LaoFab/Controller/Folder.pm \
	blib/lib/LaoFab/Controller/Folder.pm \
	lib/LaoFab/Controller/Manage.pm \
	blib/lib/LaoFab/Controller/Manage.pm \
	lib/LaoFab.pm \
	blib/lib/LaoFab.pm \
	lib/LaoFab/Schema/Phrases.pm \
	blib/lib/LaoFab/Schema/Phrases.pm \
	lib/LaoFab/Schema/UserRole.pm \
	blib/lib/LaoFab/Schema/UserRole.pm \
	lib/LaoFab/Schema/Subcats.pm \
	blib/lib/LaoFab/Schema/Subcats.pm \
	lib/LaoFab/Schema/Sessions.pm \
	blib/lib/LaoFab/Schema/Sessions.pm \
	lib/LaoFab/Controller/Stats.pm \
	blib/lib/LaoFab/Controller/Stats.pm \
	lib/LaoFab/Schema/Authors.pm \
	blib/lib/LaoFab/Schema/Authors.pm \
	lib/LaoFab/Schema/Keywords.pm \
	blib/lib/LaoFab/Schema/Keywords.pm \
	lib/LaoFab/Controller/Search.pm \
	blib/lib/LaoFab/Controller/Search.pm


# --- MakeMaker platform_constants section:
MM_Unix_VERSION = 6.42
PERL_MALLOC_DEF = -DPERL_EXTMALLOC_DEF -Dmalloc=Perl_malloc -Dfree=Perl_mfree -Drealloc=Perl_realloc -Dcalloc=Perl_calloc


# --- MakeMaker tool_autosplit section:
# Usage: $(AUTOSPLITFILE) FileToSplit AutoDirToSplitInto
AUTOSPLITFILE = $(ABSPERLRUN)  -e 'use AutoSplit;  autosplit($$ARGV[0], $$ARGV[1], 0, 1, 1)' --



# --- MakeMaker tool_xsubpp section:


# --- MakeMaker tools_other section:
SHELL = /bin/sh
CHMOD = chmod
CP = cp
MV = mv
NOOP = $(SHELL) -c true
NOECHO = @
RM_F = rm -f
RM_RF = rm -rf
TEST_F = test -f
TOUCH = touch
UMASK_NULL = umask 0
DEV_NULL = > /dev/null 2>&1
MKPATH = $(ABSPERLRUN) "-MExtUtils::Command" -e mkpath
EQUALIZE_TIMESTAMP = $(ABSPERLRUN) "-MExtUtils::Command" -e eqtime
ECHO = echo
ECHO_N = echo -n
UNINST = 0
VERBINST = 0
MOD_INSTALL = $(ABSPERLRUN) -MExtUtils::Install -e 'install({@ARGV}, '\''$(VERBINST)'\'', 0, '\''$(UNINST)'\'');' --
DOC_INSTALL = $(ABSPERLRUN) "-MExtUtils::Command::MM" -e perllocal_install
UNINSTALL = $(ABSPERLRUN) "-MExtUtils::Command::MM" -e uninstall
WARN_IF_OLD_PACKLIST = $(ABSPERLRUN) "-MExtUtils::Command::MM" -e warn_if_old_packlist
MACROSTART = 
MACROEND = 
USEMAKEFILE = -f
FIXIN = $(PERLRUN) "-MExtUtils::MY" -e "MY->fixin(shift)"


# --- MakeMaker makemakerdflt section:
makemakerdflt : all
	$(NOECHO) $(NOOP)


# --- MakeMaker dist section:
TAR = tar
TARFLAGS = cvf
ZIP = zip
ZIPFLAGS = -r
COMPRESS = gzip --best
SUFFIX = .gz
SHAR = shar
PREOP = $(PERL) -I. "-MModule::Install::Admin" -e "dist_preop(q($(DISTVNAME)))"
POSTOP = $(NOECHO) $(NOOP)
TO_UNIX = $(NOECHO) $(NOOP)
CI = ci -u
RCS_LABEL = rcs -Nv$(VERSION_SYM): -q
DIST_CP = best
DIST_DEFAULT = tardist
DISTNAME = LaoFab
DISTVNAME = LaoFab-0.01


# --- MakeMaker macro section:


# --- MakeMaker depend section:


# --- MakeMaker cflags section:


# --- MakeMaker const_loadlibs section:


# --- MakeMaker const_cccmd section:


# --- MakeMaker post_constants section:


# --- MakeMaker pasthru section:

PASTHRU = LIBPERL_A="$(LIBPERL_A)"\
	LINKTYPE="$(LINKTYPE)"\
	PREFIX="$(PREFIX)"


# --- MakeMaker special_targets section:
.SUFFIXES : .xs .c .C .cpp .i .s .cxx .cc $(OBJ_EXT)

.PHONY: all config static dynamic test linkext manifest blibdirs clean realclean disttest distdir



# --- MakeMaker c_o section:


# --- MakeMaker xs_c section:


# --- MakeMaker xs_o section:


# --- MakeMaker top_targets section:
all :: pure_all manifypods
	$(NOECHO) $(NOOP)


pure_all :: config pm_to_blib subdirs linkext
	$(NOECHO) $(NOOP)

subdirs :: $(MYEXTLIB)
	$(NOECHO) $(NOOP)

config :: $(FIRST_MAKEFILE) blibdirs
	$(NOECHO) $(NOOP)

help :
	perldoc ExtUtils::MakeMaker


# --- MakeMaker blibdirs section:
blibdirs : $(INST_LIBDIR)$(DFSEP).exists $(INST_ARCHLIB)$(DFSEP).exists $(INST_AUTODIR)$(DFSEP).exists $(INST_ARCHAUTODIR)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists $(INST_SCRIPT)$(DFSEP).exists $(INST_MAN1DIR)$(DFSEP).exists $(INST_MAN3DIR)$(DFSEP).exists
	$(NOECHO) $(NOOP)

# Backwards compat with 6.18 through 6.25
blibdirs.ts : blibdirs
	$(NOECHO) $(NOOP)

$(INST_LIBDIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_LIBDIR)
	$(NOECHO) $(CHMOD) 755 $(INST_LIBDIR)
	$(NOECHO) $(TOUCH) $(INST_LIBDIR)$(DFSEP).exists

$(INST_ARCHLIB)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_ARCHLIB)
	$(NOECHO) $(CHMOD) 755 $(INST_ARCHLIB)
	$(NOECHO) $(TOUCH) $(INST_ARCHLIB)$(DFSEP).exists

$(INST_AUTODIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_AUTODIR)
	$(NOECHO) $(CHMOD) 755 $(INST_AUTODIR)
	$(NOECHO) $(TOUCH) $(INST_AUTODIR)$(DFSEP).exists

$(INST_ARCHAUTODIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_ARCHAUTODIR)
	$(NOECHO) $(CHMOD) 755 $(INST_ARCHAUTODIR)
	$(NOECHO) $(TOUCH) $(INST_ARCHAUTODIR)$(DFSEP).exists

$(INST_BIN)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_BIN)
	$(NOECHO) $(CHMOD) 755 $(INST_BIN)
	$(NOECHO) $(TOUCH) $(INST_BIN)$(DFSEP).exists

$(INST_SCRIPT)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_SCRIPT)
	$(NOECHO) $(CHMOD) 755 $(INST_SCRIPT)
	$(NOECHO) $(TOUCH) $(INST_SCRIPT)$(DFSEP).exists

$(INST_MAN1DIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_MAN1DIR)
	$(NOECHO) $(CHMOD) 755 $(INST_MAN1DIR)
	$(NOECHO) $(TOUCH) $(INST_MAN1DIR)$(DFSEP).exists

$(INST_MAN3DIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_MAN3DIR)
	$(NOECHO) $(CHMOD) 755 $(INST_MAN3DIR)
	$(NOECHO) $(TOUCH) $(INST_MAN3DIR)$(DFSEP).exists



# --- MakeMaker linkext section:

linkext :: $(LINKTYPE)
	$(NOECHO) $(NOOP)


# --- MakeMaker dlsyms section:


# --- MakeMaker dynamic section:

dynamic :: $(FIRST_MAKEFILE) $(INST_DYNAMIC) $(INST_BOOT)
	$(NOECHO) $(NOOP)


# --- MakeMaker dynamic_bs section:

BOOTSTRAP =


# --- MakeMaker dynamic_lib section:


# --- MakeMaker static section:

## $(INST_PM) has been moved to the all: target.
## It remains here for awhile to allow for old usage: "make static"
static :: $(FIRST_MAKEFILE) $(INST_STATIC)
	$(NOECHO) $(NOOP)


# --- MakeMaker static_lib section:


# --- MakeMaker manifypods section:

POD2MAN_EXE = $(PERLRUN) "-MExtUtils::Command::MM" -e pod2man "--"
POD2MAN = $(POD2MAN_EXE)


manifypods : pure_all  \
	script/laofab_create.pl \
	script/laofab_fastcgi.pl \
	script/laofab_test.pl \
	script/laofab_cgi.pl \
	script/laofab_server.pl \
	lib/LaoFab/Controller/REST.pm \
	lib/LaoFab/Model/DB.pm \
	lib/LaoFab/View/Email/Template.pm \
	lib/LaoFab/View/TT/NoWrap.pm \
	lib/LaoFab/View/JSON.pm \
	lib/LaoFab/Controller/Export.pm \
	lib/LaoFab/Controller/Feed.pm \
	lib/LaoFab/View/HTML.pm \
	lib/LaoFab/Controller/Root.pm \
	lib/LaoFab/Controller/Page.pm \
	lib/LaoFab/Controller/User.pm \
	lib/LaoFab/Controller/Folder.pm \
	lib/LaoFab/View/Email.pm \
	lib/LaoFab/Controller/Manage.pm \
	lib/LaoFab/View/EXCEL.pm \
	lib/LaoFab.pm \
	lib/LaoFab/Controller/Document.pm \
	lib/LaoFab/Controller/Stats.pm \
	lib/LaoFab/Controller/Search.pm
	$(NOECHO) $(POD2MAN) --section=1 --perm_rw=$(PERM_RW) \
	  script/laofab_create.pl $(INST_MAN1DIR)/laofab_create.pl.$(MAN1EXT) \
	  script/laofab_fastcgi.pl $(INST_MAN1DIR)/laofab_fastcgi.pl.$(MAN1EXT) \
	  script/laofab_test.pl $(INST_MAN1DIR)/laofab_test.pl.$(MAN1EXT) \
	  script/laofab_cgi.pl $(INST_MAN1DIR)/laofab_cgi.pl.$(MAN1EXT) \
	  script/laofab_server.pl $(INST_MAN1DIR)/laofab_server.pl.$(MAN1EXT) 
	$(NOECHO) $(POD2MAN) --section=3 --perm_rw=$(PERM_RW) \
	  lib/LaoFab/Controller/REST.pm $(INST_MAN3DIR)/LaoFab::Controller::REST.$(MAN3EXT) \
	  lib/LaoFab/Model/DB.pm $(INST_MAN3DIR)/LaoFab::Model::DB.$(MAN3EXT) \
	  lib/LaoFab/View/Email/Template.pm $(INST_MAN3DIR)/LaoFab::View::Email::Template.$(MAN3EXT) \
	  lib/LaoFab/View/TT/NoWrap.pm $(INST_MAN3DIR)/LaoFab::View::TT::NoWrap.$(MAN3EXT) \
	  lib/LaoFab/View/JSON.pm $(INST_MAN3DIR)/LaoFab::View::JSON.$(MAN3EXT) \
	  lib/LaoFab/Controller/Export.pm $(INST_MAN3DIR)/LaoFab::Controller::Export.$(MAN3EXT) \
	  lib/LaoFab/Controller/Feed.pm $(INST_MAN3DIR)/LaoFab::Controller::Feed.$(MAN3EXT) \
	  lib/LaoFab/View/HTML.pm $(INST_MAN3DIR)/LaoFab::View::HTML.$(MAN3EXT) \
	  lib/LaoFab/Controller/Root.pm $(INST_MAN3DIR)/LaoFab::Controller::Root.$(MAN3EXT) \
	  lib/LaoFab/Controller/Page.pm $(INST_MAN3DIR)/LaoFab::Controller::Page.$(MAN3EXT) \
	  lib/LaoFab/Controller/User.pm $(INST_MAN3DIR)/LaoFab::Controller::User.$(MAN3EXT) \
	  lib/LaoFab/Controller/Folder.pm $(INST_MAN3DIR)/LaoFab::Controller::Folder.$(MAN3EXT) \
	  lib/LaoFab/View/Email.pm $(INST_MAN3DIR)/LaoFab::View::Email.$(MAN3EXT) \
	  lib/LaoFab/Controller/Manage.pm $(INST_MAN3DIR)/LaoFab::Controller::Manage.$(MAN3EXT) \
	  lib/LaoFab/View/EXCEL.pm $(INST_MAN3DIR)/LaoFab::View::EXCEL.$(MAN3EXT) \
	  lib/LaoFab.pm $(INST_MAN3DIR)/LaoFab.$(MAN3EXT) \
	  lib/LaoFab/Controller/Document.pm $(INST_MAN3DIR)/LaoFab::Controller::Document.$(MAN3EXT) \
	  lib/LaoFab/Controller/Stats.pm $(INST_MAN3DIR)/LaoFab::Controller::Stats.$(MAN3EXT) \
	  lib/LaoFab/Controller/Search.pm $(INST_MAN3DIR)/LaoFab::Controller::Search.$(MAN3EXT) 




# --- MakeMaker processPL section:


# --- MakeMaker installbin section:

EXE_FILES = script/laofab_cgi.pl script/laofab_create.pl script/laofab_fastcgi.pl script/laofab_server.pl script/laofab_test.pl script/laofab_update_schema.pl

pure_all :: $(INST_SCRIPT)/laofab_create.pl $(INST_SCRIPT)/laofab_fastcgi.pl $(INST_SCRIPT)/laofab_update_schema.pl $(INST_SCRIPT)/laofab_test.pl $(INST_SCRIPT)/laofab_cgi.pl $(INST_SCRIPT)/laofab_server.pl
	$(NOECHO) $(NOOP)

realclean ::
	$(RM_F) \
	  $(INST_SCRIPT)/laofab_create.pl $(INST_SCRIPT)/laofab_fastcgi.pl \
	  $(INST_SCRIPT)/laofab_update_schema.pl $(INST_SCRIPT)/laofab_test.pl \
	  $(INST_SCRIPT)/laofab_cgi.pl $(INST_SCRIPT)/laofab_server.pl 

$(INST_SCRIPT)/laofab_create.pl : script/laofab_create.pl $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/laofab_create.pl
	$(CP) script/laofab_create.pl $(INST_SCRIPT)/laofab_create.pl
	$(FIXIN) $(INST_SCRIPT)/laofab_create.pl
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/laofab_create.pl

$(INST_SCRIPT)/laofab_fastcgi.pl : script/laofab_fastcgi.pl $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/laofab_fastcgi.pl
	$(CP) script/laofab_fastcgi.pl $(INST_SCRIPT)/laofab_fastcgi.pl
	$(FIXIN) $(INST_SCRIPT)/laofab_fastcgi.pl
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/laofab_fastcgi.pl

$(INST_SCRIPT)/laofab_update_schema.pl : script/laofab_update_schema.pl $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/laofab_update_schema.pl
	$(CP) script/laofab_update_schema.pl $(INST_SCRIPT)/laofab_update_schema.pl
	$(FIXIN) $(INST_SCRIPT)/laofab_update_schema.pl
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/laofab_update_schema.pl

$(INST_SCRIPT)/laofab_test.pl : script/laofab_test.pl $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/laofab_test.pl
	$(CP) script/laofab_test.pl $(INST_SCRIPT)/laofab_test.pl
	$(FIXIN) $(INST_SCRIPT)/laofab_test.pl
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/laofab_test.pl

$(INST_SCRIPT)/laofab_cgi.pl : script/laofab_cgi.pl $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/laofab_cgi.pl
	$(CP) script/laofab_cgi.pl $(INST_SCRIPT)/laofab_cgi.pl
	$(FIXIN) $(INST_SCRIPT)/laofab_cgi.pl
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/laofab_cgi.pl

$(INST_SCRIPT)/laofab_server.pl : script/laofab_server.pl $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/laofab_server.pl
	$(CP) script/laofab_server.pl $(INST_SCRIPT)/laofab_server.pl
	$(FIXIN) $(INST_SCRIPT)/laofab_server.pl
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/laofab_server.pl



# --- MakeMaker subdirs section:

# none

# --- MakeMaker clean_subdirs section:
clean_subdirs :
	$(NOECHO) $(NOOP)


# --- MakeMaker clean section:

# Delete temporary files but do not touch installed files. We don't delete
# the Makefile here so a later make realclean still has a makefile to use.

clean :: clean_subdirs
	- $(RM_F) \
	  *$(LIB_EXT) core \
	  core.[0-9] $(INST_ARCHAUTODIR)/extralibs.all \
	  core.[0-9][0-9] $(BASEEXT).bso \
	  pm_to_blib.ts core.[0-9][0-9][0-9][0-9] \
	  $(BASEEXT).x $(BOOTSTRAP) \
	  perl$(EXE_EXT) tmon.out \
	  *$(OBJ_EXT) pm_to_blib \
	  $(INST_ARCHAUTODIR)/extralibs.ld blibdirs.ts \
	  core.[0-9][0-9][0-9][0-9][0-9] *perl.core \
	  core.*perl.*.? $(MAKE_APERL_FILE) \
	  perl $(BASEEXT).def \
	  core.[0-9][0-9][0-9] mon.out \
	  lib$(BASEEXT).def perlmain.c \
	  perl.exe so_locations \
	  $(BASEEXT).exp 
	- $(RM_RF) \
	  blib 
	- $(MV) $(FIRST_MAKEFILE) $(MAKEFILE_OLD) $(DEV_NULL)


# --- MakeMaker realclean_subdirs section:
realclean_subdirs :
	$(NOECHO) $(NOOP)


# --- MakeMaker realclean section:
# Delete temporary files (via clean) and also delete dist files
realclean purge ::  clean realclean_subdirs
	- $(RM_F) \
	  $(MAKEFILE_OLD) $(FIRST_MAKEFILE) 
	- $(RM_RF) \
	  MYMETA.yml $(DISTVNAME) 


# --- MakeMaker metafile section:
metafile :
	$(NOECHO) $(NOOP)


# --- MakeMaker signature section:
signature :
	cpansign -s


# --- MakeMaker dist_basics section:
distclean :: realclean distcheck
	$(NOECHO) $(NOOP)

distcheck :
	$(PERLRUN) "-MExtUtils::Manifest=fullcheck" -e fullcheck

skipcheck :
	$(PERLRUN) "-MExtUtils::Manifest=skipcheck" -e skipcheck

manifest :
	$(PERLRUN) "-MExtUtils::Manifest=mkmanifest" -e mkmanifest

veryclean : realclean
	$(RM_F) *~ */*~ *.orig */*.orig *.bak */*.bak *.old */*.old 



# --- MakeMaker dist_core section:

dist : $(DIST_DEFAULT) $(FIRST_MAKEFILE)
	$(NOECHO) $(ABSPERLRUN) -l -e 'print '\''Warning: Makefile possibly out of date with $(VERSION_FROM)'\''' \
	  -e '    if -e '\''$(VERSION_FROM)'\'' and -M '\''$(VERSION_FROM)'\'' < -M '\''$(FIRST_MAKEFILE)'\'';' --

tardist : $(DISTVNAME).tar$(SUFFIX)
	$(NOECHO) $(NOOP)

uutardist : $(DISTVNAME).tar$(SUFFIX)
	uuencode $(DISTVNAME).tar$(SUFFIX) $(DISTVNAME).tar$(SUFFIX) > $(DISTVNAME).tar$(SUFFIX)_uu

$(DISTVNAME).tar$(SUFFIX) : distdir
	$(PREOP)
	$(TO_UNIX)
	$(TAR) $(TARFLAGS) $(DISTVNAME).tar $(DISTVNAME)
	$(RM_RF) $(DISTVNAME)
	$(COMPRESS) $(DISTVNAME).tar
	$(POSTOP)

zipdist : $(DISTVNAME).zip
	$(NOECHO) $(NOOP)

$(DISTVNAME).zip : distdir
	$(PREOP)
	$(ZIP) $(ZIPFLAGS) $(DISTVNAME).zip $(DISTVNAME)
	$(RM_RF) $(DISTVNAME)
	$(POSTOP)

shdist : distdir
	$(PREOP)
	$(SHAR) $(DISTVNAME) > $(DISTVNAME).shar
	$(RM_RF) $(DISTVNAME)
	$(POSTOP)


# --- MakeMaker distdir section:
create_distdir :
	$(RM_RF) $(DISTVNAME)
	$(PERLRUN) "-MExtUtils::Manifest=manicopy,maniread" \
		-e "manicopy(maniread(),'$(DISTVNAME)', '$(DIST_CP)');"

distdir : create_distdir  
	$(NOECHO) $(NOOP)



# --- MakeMaker dist_test section:
disttest : distdir
	cd $(DISTVNAME) && $(ABSPERLRUN) Makefile.PL 
	cd $(DISTVNAME) && $(MAKE) $(PASTHRU)
	cd $(DISTVNAME) && $(MAKE) test $(PASTHRU)



# --- MakeMaker dist_ci section:

ci :
	$(PERLRUN) "-MExtUtils::Manifest=maniread" \
	  -e "@all = keys %{ maniread() };" \
	  -e "print(qq{Executing $(CI) @all\n}); system(qq{$(CI) @all});" \
	  -e "print(qq{Executing $(RCS_LABEL) ...\n}); system(qq{$(RCS_LABEL) @all});"


# --- MakeMaker distmeta section:
distmeta : create_distdir metafile
	$(NOECHO) cd $(DISTVNAME) && $(ABSPERLRUN) -MExtUtils::Manifest=maniadd -e 'eval { maniadd({q{META.yml} => q{Module meta-data (added by MakeMaker)}}) } ' \
	  -e '    or print "Could not add META.yml to MANIFEST: $${'\''@'\''}\n"' --



# --- MakeMaker distsignature section:
distsignature : create_distdir
	$(NOECHO) cd $(DISTVNAME) && $(ABSPERLRUN) -MExtUtils::Manifest=maniadd -e 'eval { maniadd({q{SIGNATURE} => q{Public-key signature (added by MakeMaker)}}) } ' \
	  -e '    or print "Could not add SIGNATURE to MANIFEST: $${'\''@'\''}\n"' --
	$(NOECHO) cd $(DISTVNAME) && $(TOUCH) SIGNATURE
	cd $(DISTVNAME) && cpansign -s



# --- MakeMaker install section:

install :: all pure_install doc_install
	$(NOECHO) $(NOOP)

install_perl :: all pure_perl_install doc_perl_install
	$(NOECHO) $(NOOP)

install_site :: all pure_site_install doc_site_install
	$(NOECHO) $(NOOP)

install_vendor :: all pure_vendor_install doc_vendor_install
	$(NOECHO) $(NOOP)

pure_install :: pure_$(INSTALLDIRS)_install
	$(NOECHO) $(NOOP)

doc_install :: doc_$(INSTALLDIRS)_install
	$(NOECHO) $(NOOP)

pure__install : pure_site_install
	$(NOECHO) $(ECHO) INSTALLDIRS not defined, defaulting to INSTALLDIRS=site

doc__install : doc_site_install
	$(NOECHO) $(ECHO) INSTALLDIRS not defined, defaulting to INSTALLDIRS=site

pure_perl_install ::
	$(NOECHO) $(MOD_INSTALL) \
		read $(PERL_ARCHLIB)/auto/$(FULLEXT)/.packlist \
		write $(DESTINSTALLARCHLIB)/auto/$(FULLEXT)/.packlist \
		$(INST_LIB) $(DESTINSTALLPRIVLIB) \
		$(INST_ARCHLIB) $(DESTINSTALLARCHLIB) \
		$(INST_BIN) $(DESTINSTALLBIN) \
		$(INST_SCRIPT) $(DESTINSTALLSCRIPT) \
		$(INST_MAN1DIR) $(DESTINSTALLMAN1DIR) \
		$(INST_MAN3DIR) $(DESTINSTALLMAN3DIR)
	$(NOECHO) $(WARN_IF_OLD_PACKLIST) \
		$(SITEARCHEXP)/auto/$(FULLEXT)


pure_site_install ::
	$(NOECHO) $(MOD_INSTALL) \
		read $(SITEARCHEXP)/auto/$(FULLEXT)/.packlist \
		write $(DESTINSTALLSITEARCH)/auto/$(FULLEXT)/.packlist \
		$(INST_LIB) $(DESTINSTALLSITELIB) \
		$(INST_ARCHLIB) $(DESTINSTALLSITEARCH) \
		$(INST_BIN) $(DESTINSTALLSITEBIN) \
		$(INST_SCRIPT) $(DESTINSTALLSITESCRIPT) \
		$(INST_MAN1DIR) $(DESTINSTALLSITEMAN1DIR) \
		$(INST_MAN3DIR) $(DESTINSTALLSITEMAN3DIR)
	$(NOECHO) $(WARN_IF_OLD_PACKLIST) \
		$(PERL_ARCHLIB)/auto/$(FULLEXT)

pure_vendor_install ::
	$(NOECHO) $(MOD_INSTALL) \
		read $(VENDORARCHEXP)/auto/$(FULLEXT)/.packlist \
		write $(DESTINSTALLVENDORARCH)/auto/$(FULLEXT)/.packlist \
		$(INST_LIB) $(DESTINSTALLVENDORLIB) \
		$(INST_ARCHLIB) $(DESTINSTALLVENDORARCH) \
		$(INST_BIN) $(DESTINSTALLVENDORBIN) \
		$(INST_SCRIPT) $(DESTINSTALLVENDORSCRIPT) \
		$(INST_MAN1DIR) $(DESTINSTALLVENDORMAN1DIR) \
		$(INST_MAN3DIR) $(DESTINSTALLVENDORMAN3DIR)

doc_perl_install ::
	$(NOECHO) $(ECHO) Appending installation info to $(DESTINSTALLARCHLIB)/perllocal.pod
	-$(NOECHO) $(MKPATH) $(DESTINSTALLARCHLIB)
	-$(NOECHO) $(DOC_INSTALL) \
		"Module" "$(NAME)" \
		"installed into" "$(INSTALLPRIVLIB)" \
		LINKTYPE "$(LINKTYPE)" \
		VERSION "$(VERSION)" \
		EXE_FILES "$(EXE_FILES)" \
		>> $(DESTINSTALLARCHLIB)/perllocal.pod

doc_site_install ::
	$(NOECHO) $(ECHO) Appending installation info to $(DESTINSTALLARCHLIB)/perllocal.pod
	-$(NOECHO) $(MKPATH) $(DESTINSTALLARCHLIB)
	-$(NOECHO) $(DOC_INSTALL) \
		"Module" "$(NAME)" \
		"installed into" "$(INSTALLSITELIB)" \
		LINKTYPE "$(LINKTYPE)" \
		VERSION "$(VERSION)" \
		EXE_FILES "$(EXE_FILES)" \
		>> $(DESTINSTALLARCHLIB)/perllocal.pod

doc_vendor_install ::
	$(NOECHO) $(ECHO) Appending installation info to $(DESTINSTALLARCHLIB)/perllocal.pod
	-$(NOECHO) $(MKPATH) $(DESTINSTALLARCHLIB)
	-$(NOECHO) $(DOC_INSTALL) \
		"Module" "$(NAME)" \
		"installed into" "$(INSTALLVENDORLIB)" \
		LINKTYPE "$(LINKTYPE)" \
		VERSION "$(VERSION)" \
		EXE_FILES "$(EXE_FILES)" \
		>> $(DESTINSTALLARCHLIB)/perllocal.pod


uninstall :: uninstall_from_$(INSTALLDIRS)dirs
	$(NOECHO) $(NOOP)

uninstall_from_perldirs ::
	$(NOECHO) $(UNINSTALL) $(PERL_ARCHLIB)/auto/$(FULLEXT)/.packlist

uninstall_from_sitedirs ::
	$(NOECHO) $(UNINSTALL) $(SITEARCHEXP)/auto/$(FULLEXT)/.packlist

uninstall_from_vendordirs ::
	$(NOECHO) $(UNINSTALL) $(VENDORARCHEXP)/auto/$(FULLEXT)/.packlist


# --- MakeMaker force section:
# Phony target to force checking subdirectories.
FORCE :
	$(NOECHO) $(NOOP)


# --- MakeMaker perldepend section:


# --- MakeMaker makefile section:
# We take a very conservative approach here, but it's worth it.
# We move Makefile to Makefile.old here to avoid gnu make looping.
$(FIRST_MAKEFILE) : Makefile.PL $(CONFIGDEP)
	$(NOECHO) $(ECHO) "Makefile out-of-date with respect to $?"
	$(NOECHO) $(ECHO) "Cleaning current config before rebuilding Makefile..."
	-$(NOECHO) $(RM_F) $(MAKEFILE_OLD)
	-$(NOECHO) $(MV)   $(FIRST_MAKEFILE) $(MAKEFILE_OLD)
	- $(MAKE) $(USEMAKEFILE) $(MAKEFILE_OLD) clean $(DEV_NULL)
	$(PERLRUN) Makefile.PL 
	$(NOECHO) $(ECHO) "==> Your Makefile has been rebuilt. <=="
	$(NOECHO) $(ECHO) "==> Please rerun the $(MAKE) command.  <=="
	false



# --- MakeMaker staticmake section:

# --- MakeMaker makeaperl section ---
MAP_TARGET    = perl
FULLPERL      = /usr/local/bin/perl

$(MAP_TARGET) :: static $(MAKE_APERL_FILE)
	$(MAKE) $(USEMAKEFILE) $(MAKE_APERL_FILE) $@

$(MAKE_APERL_FILE) : $(FIRST_MAKEFILE) pm_to_blib
	$(NOECHO) $(ECHO) Writing \"$(MAKE_APERL_FILE)\" for this $(MAP_TARGET)
	$(NOECHO) $(PERLRUNINST) \
		Makefile.PL DIR= \
		MAKEFILE=$(MAKE_APERL_FILE) LINKTYPE=static \
		MAKEAPERL=1 NORECURS=1 CCCDLFLAGS=


# --- MakeMaker test section:

TEST_VERBOSE=0
TEST_TYPE=test_$(LINKTYPE)
TEST_FILE = test.pl
TEST_FILES = t/01app.t t/02pod.t t/03podcoverage.t t/controller_Export.t t/controller_Feed.t t/controller_Manage.t t/controller_Page.t t/controller_REST.t t/controller_Search.t t/controller_Stats.t t/controller_User.t t/live_login.t t/model_DB.t t/view_Email-Template.t t/view_Email.t t/view_JSON.t
TESTDB_SW = -d

testdb :: testdb_$(LINKTYPE)

test :: $(TEST_TYPE) subdirs-test

subdirs-test ::
	$(NOECHO) $(NOOP)


test_dynamic :: pure_all
	PERL_DL_NONLAZY=1 $(FULLPERLRUN) "-MExtUtils::Command::MM" "-e" "test_harness($(TEST_VERBOSE), 'inc', '$(INST_LIB)', '$(INST_ARCHLIB)')" $(TEST_FILES)

testdb_dynamic :: pure_all
	PERL_DL_NONLAZY=1 $(FULLPERLRUN) $(TESTDB_SW) "-Iinc" "-I$(INST_LIB)" "-I$(INST_ARCHLIB)" $(TEST_FILE)

test_ : test_dynamic

test_static :: test_dynamic
testdb_static :: testdb_dynamic


# --- MakeMaker ppd section:
# Creates a PPD (Perl Package Description) for a binary distribution.
ppd :
	$(NOECHO) $(ECHO) '<SOFTPKG NAME="$(DISTNAME)" VERSION="0,01,0,0">' > $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '    <TITLE>$(DISTNAME)</TITLE>' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '    <ABSTRACT>Catalyst based application</ABSTRACT>' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '    <AUTHOR>Joakim Lagerqvist</AUTHOR>' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '    <IMPLEMENTATION>' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <DEPENDENCY NAME="Catalyst-Action-RenderView" VERSION="0,0,0,0" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <DEPENDENCY NAME="Catalyst-Plugin-ConfigLoader" VERSION="0,0,0,0" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <DEPENDENCY NAME="Catalyst-Plugin-Static-Simple" VERSION="0,0,0,0" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <DEPENDENCY NAME="Catalyst-Runtime" VERSION="5,71000,0,0" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <DEPENDENCY NAME="Config-General" VERSION="0,0,0,0" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <DEPENDENCY NAME="ExtUtils-MakeMaker" VERSION="6,42,0,0" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <DEPENDENCY NAME="parent" VERSION="0,0,0,0" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <OS NAME="$(OSNAME)" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <ARCHITECTURE NAME="darwin-2level-5.1" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <CODEBASE HREF="" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '    </IMPLEMENTATION>' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '</SOFTPKG>' >> $(DISTNAME).ppd


# --- MakeMaker pm_to_blib section:

pm_to_blib : $(TO_INST_PM)
	$(NOECHO) $(ABSPERLRUN) -MExtUtils::Install -e 'pm_to_blib({@ARGV}, '\''$(INST_LIB)/auto'\'', '\''$(PM_FILTER)'\'')' -- \
	  lib/LaoFab/ResultSet/Documents.pm blib/lib/LaoFab/ResultSet/Documents.pm \
	  lib/LaoFab/Schema/Tags.pm blib/lib/LaoFab/Schema/Tags.pm \
	  lib/LaoFab/Schema/Buzz3.pm blib/lib/LaoFab/Schema/Buzz3.pm \
	  lib/LaoFab/Controller/REST.pm blib/lib/LaoFab/Controller/REST.pm \
	  lib/LaoFab/Schema/Buzz2.pm blib/lib/LaoFab/Schema/Buzz2.pm \
	  lib/LaoFab/View/TT/NoWrap.pm blib/lib/LaoFab/View/TT/NoWrap.pm \
	  lib/LaoFab/.DS_Store blib/lib/LaoFab/.DS_Store \
	  lib/LaoFab/Schema/Documents.pm blib/lib/LaoFab/Schema/Documents.pm \
	  lib/LaoFab/Test/Database/Live.pm blib/lib/LaoFab/Test/Database/Live.pm \
	  lib/LaoFab/Schema/Roles.pm blib/lib/LaoFab/Schema/Roles.pm \
	  lib/LaoFab/Schema/Downloads.pm blib/lib/LaoFab/Schema/Downloads.pm \
	  lib/LaoFab/Schema.pm blib/lib/LaoFab/Schema.pm \
	  lib/LaoFab/View/HTML.pm blib/lib/LaoFab/View/HTML.pm \
	  lib/LaoFab/Controller/Root.pm blib/lib/LaoFab/Controller/Root.pm \
	  lib/LaoFab/Controller/.DS_Store blib/lib/LaoFab/Controller/.DS_Store \
	  lib/LaoFab/Controller/Feed.pm blib/lib/LaoFab/Controller/Feed.pm \
	  lib/LaoFab/Schema/Photos.pm blib/lib/LaoFab/Schema/Photos.pm \
	  lib/LaoFab/Controller/Page.pm blib/lib/LaoFab/Controller/Page.pm \
	  lib/LaoFab/Controller/User.pm blib/lib/LaoFab/Controller/User.pm \
	  lib/LaoFab/Schema/Content.pm blib/lib/LaoFab/Schema/Content.pm \
	  lib/LaoFab/View/Email.pm blib/lib/LaoFab/View/Email.pm \
	  lib/LaoFab/Schema/DocumentSubcat.pm blib/lib/LaoFab/Schema/DocumentSubcat.pm \
	  lib/LaoFab/Schema/UserRole.pm.org blib/lib/LaoFab/Schema/UserRole.pm.org \
	  lib/LaoFab/View/EXCEL.pm blib/lib/LaoFab/View/EXCEL.pm \
	  lib/LaoFab/Controller/Document.pm blib/lib/LaoFab/Controller/Document.pm \
	  lib/LaoFab/Schema/User.pm blib/lib/LaoFab/Schema/User.pm \
	  lib/LaoFab/Schema/Logins.pm blib/lib/LaoFab/Schema/Logins.pm \
	  lib/LaoFab/Schema/Folders.pm blib/lib/LaoFab/Schema/Folders.pm \
	  lib/LaoFab/Schema/FirstPage.pm blib/lib/LaoFab/Schema/FirstPage.pm \
	  lib/LaoFab/Model/DB.pm blib/lib/LaoFab/Model/DB.pm \
	  lib/LaoFab/Schema/Doctypes.pm blib/lib/LaoFab/Schema/Doctypes.pm \
	  lib/LaoFab/View/Email/Template.pm blib/lib/LaoFab/View/Email/Template.pm \
	  lib/LaoFab/Schema/Comments.pm blib/lib/LaoFab/Schema/Comments.pm \
	  lib/LaoFab/View/JSON.pm blib/lib/LaoFab/View/JSON.pm \
	  lib/LaoFab/Schema/PhotoAlbum.pm blib/lib/LaoFab/Schema/PhotoAlbum.pm \
	  lib/LaoFab/Controller/Export.pm blib/lib/LaoFab/Controller/Export.pm \
	  lib/LaoFab/Schema/Albums.pm blib/lib/LaoFab/Schema/Albums.pm \
	  lib/LaoFab/Schema/DocumentFolder.pm blib/lib/LaoFab/Schema/DocumentFolder.pm \
	  lib/LaoFab/View/.DS_Store blib/lib/LaoFab/View/.DS_Store \
	  lib/LaoFab/Schema/Role.pm blib/lib/LaoFab/Schema/Role.pm \
	  lib/LaoFab/Schema/Buzz1.pm blib/lib/LaoFab/Schema/Buzz1.pm \
	  lib/LaoFab/Schema/Mimes.pm blib/lib/LaoFab/Schema/Mimes.pm \
	  lib/LaoFab/Model/DB.pm.new blib/lib/LaoFab/Model/DB.pm.new \
	  lib/LaoFab/Schema/Users.pm blib/lib/LaoFab/Schema/Users.pm \
	  lib/LaoFab/Controller/Folder.pm blib/lib/LaoFab/Controller/Folder.pm \
	  lib/LaoFab/Controller/Manage.pm blib/lib/LaoFab/Controller/Manage.pm \
	  lib/LaoFab.pm blib/lib/LaoFab.pm \
	  lib/LaoFab/Schema/Phrases.pm blib/lib/LaoFab/Schema/Phrases.pm \
	  lib/LaoFab/Schema/UserRole.pm blib/lib/LaoFab/Schema/UserRole.pm \
	  lib/LaoFab/Schema/Subcats.pm blib/lib/LaoFab/Schema/Subcats.pm \
	  lib/LaoFab/Schema/Sessions.pm blib/lib/LaoFab/Schema/Sessions.pm \
	  lib/LaoFab/Controller/Stats.pm blib/lib/LaoFab/Controller/Stats.pm \
	  lib/LaoFab/Schema/Authors.pm blib/lib/LaoFab/Schema/Authors.pm \
	  lib/LaoFab/Schema/Keywords.pm blib/lib/LaoFab/Schema/Keywords.pm \
	  lib/LaoFab/Controller/Search.pm blib/lib/LaoFab/Controller/Search.pm 
	$(NOECHO) $(TOUCH) pm_to_blib


# --- MakeMaker selfdocument section:


# --- MakeMaker postamble section:


# End.
# Postamble by Module::Install 0.84
# --- Module::Install::Admin::Makefile section:

realclean purge ::
	$(RM_F) $(DISTVNAME).tar$(SUFFIX)
	$(RM_F) MANIFEST.bak _build
	$(PERL) "-Ilib" "-MModule::Install::Admin" -e "remove_meta()"
	$(RM_RF) inc

reset :: purge

upload :: test dist
	cpan-upload -verbose $(DISTVNAME).tar$(SUFFIX)

grok ::
	perldoc Module::Install

distsign ::
	cpansign -s

catalyst_par :: all
	$(NOECHO) $(PERL) -Ilib -Minc::Module::Install -MModule::Install::Catalyst -e"Catalyst::Module::Install::_catalyst_par( '', 'LaoFab', { CLASSES => [], CORE => 0, ENGINE => 'CGI', MULTIARCH => 0, SCRIPT => '', USAGE => q## } )"
# --- Module::Install::AutoInstall section:

config :: installdeps
	$(NOECHO) $(NOOP)

checkdeps ::
	$(PERL) Makefile.PL --checkdeps

installdeps ::
	$(NOECHO) $(NOOP)

